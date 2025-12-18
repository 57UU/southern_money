import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_post.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/post_card.dart';
import 'package:southern_money/widgets/utilities.dart';
import 'package:southern_money/pages/post_viewer.dart';

class PostsByUser extends StatefulWidget {
  final PostUploaderResponse user;
  const PostsByUser({super.key, required this.user});

  @override
  State<PostsByUser> createState() => _PostsByUserState();
}

class _PostsByUserState extends State<PostsByUser> {
  final postService = getIt<ApiPostService>();
  final ScrollController _scrollController = ScrollController();

  // 状态变量
  List<PostPageItemResponse> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPosts();

    // 添加滚动监听，实现无限滚动
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 加载用户帖子
  Future<void> _loadPosts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await postService.getPostByUserId(
        userId: widget.user.id.toString(),
        page: 1,
        pageSize: 10,
      );

      if (response.success && response.data != null) {
        setState(() {
          _posts = response.data!.items;
          _hasMore = _posts.length == 10; // 如果返回的数据等于页面大小，说明还有更多数据
          _currentPage = 1;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? "获取帖子失败";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "网络错误，请重试";
        _isLoading = false;
      });
    }
  }

  // 加载更多帖子
  Future<void> _loadMorePosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await postService.getPostByUserId(
        userId: widget.user.id.toString(),
        page: _currentPage + 1,
        pageSize: 10,
      );

      if (response.success && response.data != null) {
        setState(() {
          _posts.addAll(response.data!.items);
          _hasMore = response.data!.items.length == 10;
          _currentPage++;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 刷新数据
  Future<void> _refreshPosts() async {
    await _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user.name}的帖子"),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: Column(
          children: [
            // 用户信息卡片
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 用户头像
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        widget.user.avatarUrl,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        errorBuilder: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.person,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 用户名和ID
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "用户ID: ${widget.user.id}",
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 帖子列表
            Expanded(child: _buildPostsList(colorScheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList(ColorScheme colorScheme) {
    if (_isLoading && _posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _refreshPosts, child: const Text("重试")),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "该用户还没有发布任何帖子",
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _posts.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _posts.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final post = _posts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: PostCard(
            content: post.content,
            title: post.title,
            author: post.uploader.name,
            timeAgo: formatTimeAgo(post.createTime),
            avaterUrl: post.uploader.avatarUrl,
            onTap: () {
              PostViewer.show(context, post);
            },
          ),
        );
      },
    );
  }
}
