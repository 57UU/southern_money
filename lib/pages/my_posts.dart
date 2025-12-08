import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/post_viewer.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_post.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/post_card.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:southern_money/widgets/utilities.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final postService = getIt<ApiPostService>();

  List<PostPageItemResponse> _posts = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      if (isRefresh) {
        _currentPage = 1;
        _posts = [];
        _hasMore = true;
      }
    });

    try {
      final response = await postService.getMyPosts(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response.success && response.data != null) {
        setState(() {
          if (_currentPage == 1) {
            _posts = response.data!.items;
          } else {
            _posts.addAll(response.data!.items);
          }

          _hasMore = _posts.length < (response.data!.totalCount ?? 0);
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? '加载失败';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载失败: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    await _loadPosts(isRefresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    await _loadPosts();
  }

  Widget _buildPostItem(PostPageItemResponse post) {
    return PostCard(
      avaterUrl: post.uploader.avatarUrl,
      content: post.content,
      title: post.title,
      author: post.uploader.name,
      timeAgo: formatTimeAgo(post.createTime),
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => PostViewer(post: post)),
        );
      },
      onMorePressed: () {
        // 显示更多操作选项
        _showMoreOptionsDialog(post);
      },
      isBlocked: post.isBlocked,
      postBlocks: post.postBlocks,
      onBlockInfoPressed: () => _showBlockReasonDialog(post),
    );
  }

  void _showBlockReasonDialog(PostPageItemResponse post) {
    if (post.postBlocks.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red.shade700),
              const SizedBox(width: 8),
              const Text('封禁详情'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: post.postBlocks
                  .map(
                    (block) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '封禁原因: ${block.reason}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('操作人: ${block.operator.name}'),
                          Text('操作时间: ${formatTimeAgo(block.actionTime)}'),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showMoreOptionsDialog(PostPageItemResponse post) {
    // 这里可以实现更多操作的对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('操作选项'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!post.isBlocked) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('编辑帖子'),
                  onTap: () {
                    //need implement
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('编辑帖子功能暂未实现')));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('删除帖子'),
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    // 实现删除帖子的逻辑
                    _deletePost(post.id);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: Icon(Icons.block, color: Colors.red.shade700),
                  title: Text(
                    '帖子已被封禁',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  subtitle: const Text('被封禁的帖子无法编辑或删除'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _deletePost(String postId) async {
    // 这里可以实现删除帖子的逻辑
    try {
      final response = await postService.deletePost(postId);
      if (response.success) {
        setState(() {
          _posts.removeWhere((post) => post.id == postId);
        });
      } else {
        // 显示删除失败的提示
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message ?? '删除失败')));
      }
    } catch (e) {
      // 显示删除失败的提示
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
    }
  }

  Widget _buildLoadingIndicator() {
    if (!_isLoadingMore) return const SizedBox.shrink();

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorView() {
    if (_errorMessage == null) return const SizedBox.shrink();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadPosts, child: const Text('重试')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    if (_posts.isNotEmpty || _isLoading) return const SizedBox.shrink();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.post_add,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          const Text('你还没有发布过帖子'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/post_create');
            },
            child: const Text('发布第一篇帖子'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("我的帖子")),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _posts.length + 1,
              itemBuilder: (context, index) {
                if (index < _posts.length) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildPostItem(_posts[index]),
                  );
                } else {
                  return _buildLoadingIndicator();
                }
              },
            ),
            if (_isLoading && _posts.isEmpty)
              const Center(child: CircularProgressIndicator()),
            _buildErrorView(),
            _buildEmptyView(),
          ],
        ),
      ),
    );
  }
}
