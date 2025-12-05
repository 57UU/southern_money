import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/api_post.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
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
  bool isLiked = false;
  int likeCount = 0;
  bool isReporting = false;

  @override
  void initState() {
    super.initState();
    // 初始化点赞状态
    isLiked = widget.post.isLiked;
    likeCount = widget.post.likeCount;
  }

  // 格式化时间
  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return "刚刚";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}分钟前";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}小时前";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}天前";
    } else {
      return "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
    }
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

  // 举报功能
  Future<void> reportPost() async {
    if (isReporting) return;

    setState(() {
      isReporting = true;
    });

    String reason =
        await showDialog(
          context: context,
          builder: (context) {
            TextEditingController reasonController = TextEditingController();
            return AlertDialog(
              title: const Text("举报帖子"),
              content: TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "请输入举报原因"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, ""),
                  child: const Text("取消"),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, reasonController.text),
                  child: const Text("确定"),
                ),
              ],
            );
          },
        ) ??
        "";

    if (reason.trim().isEmpty) {
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
                Row(
                  children: [
                    // 头像
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: widget.post.uploader.avatar != null
                          ? CachedNetworkImageProvider(
                              imageService.getImageUrl(
                                widget.post.uploader.avatar!,
                              ),
                            )
                          : avatarPlaceholder,
                      backgroundColor: colorScheme.surfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    // 用户名
                    Text(
                      widget.post.uploader.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                // 创建时间和更多按钮
                Row(
                  children: [
                    Text(
                      formatTime(widget.post.createTime),
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
                      itemBuilder: (BuildContext context) => [
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
                      ],
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
                  return Chip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        color: colorScheme.onSecondaryContainer,
                        fontSize: 14,
                      ),
                    ),
                    backgroundColor: colorScheme.secondaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
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
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
