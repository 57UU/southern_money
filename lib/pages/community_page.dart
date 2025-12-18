import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/community_search_page.dart';
import 'package:southern_money/pages/post_page.dart';
import 'package:southern_money/pages/post_viewer.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_post.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import '../widgets/post_card.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with AutomaticKeepAliveClientMixin {
  final postService = getIt<ApiPostService>();

  // 分页相关状态
  int _currentPage = 1;
  int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoading = false;
  List<PostPageItemResponse> _posts = [];
  ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadPosts();

    // 监听滚动事件，实现懒加载
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

  // 加载帖子列表
  Future<void> _loadPosts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await postService.getPostPage(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response.success && response.data != null) {
        setState(() {
          _posts.addAll(response.data!.items);
          _hasMore =
              _posts.length < (response.data!.totalCount ?? _posts.length + 1);
          _currentPage++;
        });
      }
    } catch (e) {
      print('加载帖子失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void refresh() {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
      _posts.clear();
    });
    _loadPosts();
  }

  // 加载更多帖子
  void _loadMorePosts() {
    if (!_isLoading && _hasMore) {
      _loadPosts();
    }
  }

  final appConfigService = getIt<AppConfigService>();

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以使 AutomaticKeepAliveClientMixin 生效
    scheduleMicrotask(() {
      if (appConfigService.forumNeedRefresh) {
        refresh();
        appConfigService.forumNeedRefresh = false;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('社区'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // 重置所有状态并重新加载数据
              refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const CommunitySearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => PostPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 帖子列表
          Expanded(
            child: _posts.isEmpty
                ? _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Center(child: Text('暂无帖子'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _posts.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _posts.length) {
                        // 加载更多的指示器
                        return _buildLoadMoreWidget();
                      }
                      return _buildPostCard(context, _posts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, PostPageItemResponse post) {
    return PostCard(
      content: post.content,
      title: post.title,
      author: post.uploader.name,
      timeAgo: '',
      onTap: () => PostViewer.show(context, post),
      avaterUrl: post.uploader.avatarUrl,
    );
  }

  Widget _buildLoadMoreWidget() {
    if (!_hasMore) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: const Text(
          '已全部显示',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
