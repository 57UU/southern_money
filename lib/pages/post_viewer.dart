import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/community_search_page.dart';
import 'package:southern_money/pages/posts_by_user.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/api_post.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/common_widget.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:southern_money/widgets/router_utils.dart';
import 'package:southern_money/widgets/utilities.dart';

class PostViewer extends StatefulWidget {
  final PostPageItemResponse post;
  const PostViewer({super.key, required this.post});

  @override
  State<PostViewer> createState() => _PostViewerState();
  static void show(BuildContext context, PostPageItemResponse post) {
    popupOrNavigate(context, PostViewer(post: post));
  }
}

class _PostViewerState extends State<PostViewer> {
  // 服务
  final ApiImageService imageService = getIt<ApiImageService>();
  final ApiPostService postService = getIt<ApiPostService>();

  // 状态
  get isLiked => widget.post.isLiked;
  set isLiked(bool value) {
    widget.post.isLiked = value;
  }

  get isFavorited => widget.post.isFavorited;
  set isFavorited(bool value) {
    widget.post.isFavorited = value;
  }

  int likeCount = 0;
  bool isReporting = false;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 初始化点赞状态
    likeCount = widget.post.likeCount;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  // 点赞功能
  Future<void> toggleLike() async {
    if (isLiked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("您已点赞过该帖子"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    try {
      final response = await postService.likePost(widget.post.id);
      if (response.success) {
        setState(() {
          // 切换点赞状态
          isLiked = true;
          // 优先使用API返回的点赞数，确保数据准确性
          likeCount = response.data?.likeCount ?? likeCount + 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("点赞成功"), duration: const Duration(seconds: 2)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "操作失败"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("网络错误，请重试"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // 收藏功能
  Future<void> toggleFavorite() async {
    try {
      ApiResponse response;

      if (isFavorited) {
        // 取消收藏
        response = await postService.unfavoritePost(widget.post.id);
      } else {
        // 收藏
        response = await postService.favoritePost(widget.post.id);
      }

      if (response.success) {
        setState(() {
          // 切换收藏状态
          isFavorited = !isFavorited;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFavorited ? "收藏成功" : "已取消收藏"),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "操作失败"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("网络错误，请重试"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // 显示封禁原因对话框
  void _showBlockReasonDialog(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    if (widget.post.postBlocks.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("封禁详情", style: TextStyle(color: colorScheme.onSurface)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.post.postBlocks.map((block) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "封禁原因:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      block.reason,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "操作人: ${block.operator}",
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "操作时间: ${formatTimeAgo(block.actionTime)}",
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("确定", style: TextStyle(color: colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  // 举报功能
  Future<void> reportPost() async {
    if (isReporting) return;

    setState(() {
      isReporting = true;
    });

    // 清空之前的内容
    _reasonController.clear();
    String? reason;

    // 显示输入对话框
    reason = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('举报帖子'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('请输入举报原因'),
              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  hintText: '请详细描述举报原因',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (_reasonController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(_reasonController.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("请输入举报原因"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('举报'),
            ),
          ],
        );
      },
    );

    if (reason == null || reason.isEmpty) {
      setState(() {
        isReporting = false;
      });
      return;
    }

    try {
      await apiRequestDialog(
        postService.reportPost(postId: widget.post.id, reason: reason),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("网络错误，请重试"),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isReporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('帖子详情'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封禁警告
            if (widget.post.isBlocked) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.error),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: colorScheme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "此帖子已被封禁",
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (widget.post.postBlocks.isNotEmpty)
                      TextButton(
                        onPressed: () => _showBlockReasonDialog(context),
                        child: Text(
                          "查看原因",
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // 帖子标题
            Text(
              widget.post.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // 上传者信息和创建时间
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Uploader(
                  avatarUrl: widget.post.uploader.avatarUrl,
                  name: widget.post.uploader.name,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            PostsByUser(user: widget.post.uploader),
                      ),
                    );
                  },
                ),
                // 创建时间和更多按钮
                Row(
                  children: [
                    Text(
                      formatTimeAgo(widget.post.createTime),
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 更多操作按钮
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (value) {
                        if (value == 'report') {
                          reportPost();
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        if (widget.post.isBlocked) {
                          return [
                            const PopupMenuItem<String>(
                              enabled: false,
                              child: Row(
                                children: [
                                  Icon(Icons.block, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    '帖子已被封禁',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        } else {
                          return [
                            const PopupMenuItem<String>(
                              value: 'report',
                              child: Row(
                                children: [
                                  Icon(Icons.report, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('举报'),
                                ],
                              ),
                            ),
                          ];
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 帖子内容
            Text(
              widget.post.content,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),

            // 帖子图片
            if (widget.post.imageIds.isNotEmpty) ...[
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.post.imageIds.length,
                  itemBuilder: (context, index) {
                    final imageId = widget.post.imageIds[index];
                    final imageUrl = imageService.getImageUrl(imageId);

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colorScheme.surfaceVariant,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colorScheme.surfaceVariant,
                              ),
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 标签
            if (widget.post.tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.post.tags.map((tag) {
                  return Tag(
                    tag: tag,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              CommunitySearchPage(initialQuery: "#$tag"),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // 统计信息
            Row(
              children: [
                // 浏览数
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.post.viewCount.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // 点赞数
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      likeCount.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // 收藏数
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "收藏", // 暂时显示"收藏"，因为API没有返回收藏数
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 互动按钮
            Row(
              children: [
                // 点赞按钮
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: toggleLike,
                    icon: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: isLiked
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    label: Text(
                      isLiked ? "已点赞" : "点赞",
                      style: TextStyle(
                        color: isLiked
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(
                        color: isLiked
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 收藏按钮
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: toggleFavorite,
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited
                          ? Colors.red
                          : colorScheme.onSurfaceVariant,
                    ),
                    label: Text(
                      isFavorited ? "已收藏" : "收藏",
                      style: TextStyle(
                        color: isFavorited
                            ? Colors.red
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(
                        color: isFavorited ? Colors.red : colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
