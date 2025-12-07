import 'package:cached_network_image/cached_network_image.dart';
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

  int likeCount = 0;
  bool isReporting = false;

  @override
  void initState() {
    super.initState();
    // 初始化点赞状态
    likeCount = widget.post.likeCount;
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

    final isConfirmed =
        (await showYesNoDialog(title: "举报帖子", content: "确定举报该帖子吗？")) == true;

    if (!isConfirmed) {
      setState(() {
        isReporting = false;
      });
      return;
    }

    try {
      await apiRequestDialog(
        postService.reportPost(postId: widget.post.id, reason: ""),
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
