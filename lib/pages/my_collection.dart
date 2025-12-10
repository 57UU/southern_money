import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/post_viewer.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_post.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/post_card.dart';
// import 'package:southern_money/widgets/common_widget.dart';
import 'package:southern_money/widgets/utilities.dart';

class MyCollection extends StatefulWidget {
  const MyCollection({super.key});

  @override
  State<MyCollection> createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  final ScrollController _scrollController = ScrollController();
  final List<PostPageItemResponse> _favoritePosts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavoritePosts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  final apiService = getIt<ApiPostService>();
  Future<void> _loadFavoritePosts({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      if (isRefresh) {
        _currentPage = 1;
        _hasMore = true;
        _favoritePosts.clear();
      }
    });

    try {
      final response = await apiService.getFavoritePosts(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response.success && response.data != null) {
        setState(() {
          if (isRefresh) {
            _favoritePosts.clear();
          }
          _favoritePosts.addAll(response.data!.items);
          _hasMore = response.data!.items.length == _pageSize;
          _currentPage++;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? '获取收藏帖子失败';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '网络错误，请稍后重试';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMorePosts() async {
    if (!_hasMore || _isLoading) return;
    await _loadFavoritePosts();
  }

  Future<void> _refreshPosts() async {
    await _loadFavoritePosts(isRefresh: true);
  }

  void _navigateToPost(PostPageItemResponse post) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => PostViewer(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收藏')),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: Padding(padding: EdgeInsets.all(16), child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null && _favoritePosts.isEmpty) {
      return _buildErrorWidget();
    }

    if (_favoritePosts.isEmpty && !_isLoading) {
      return _buildEmptyWidget();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _favoritePosts.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _favoritePosts.length) {
                return _buildLoadingIndicator();
              }

              final post = _favoritePosts[index];
              return PostCard(
                title: post.title,
                content: post.content,
                author: post.uploader.name,
                timeAgo: formatTimeAgo(post.createTime),
                avaterUrl: post.uploader.avatarUrl,
                onTap: () => _navigateToPost(post),
                isBlocked: post.isBlocked,
                postBlocks: post.postBlocks,
                onBlockInfoPressed: () {
                  // 显示封禁信息
                },
              );
            },
          ),
        ),
        if (_errorMessage != null && _favoritePosts.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _refreshPosts,
                  child: Text(
                    '重试',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无收藏的帖子',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? '加载失败',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _refreshPosts, child: const Text('重试')),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
