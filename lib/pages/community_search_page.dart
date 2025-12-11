import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_post.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import '../setting/app_config.dart';
import 'post_viewer.dart';

class CommunitySearchPage extends StatefulWidget {
  final bool autoFocus;
  final String? initialQuery;
  const CommunitySearchPage({
    super.key,
    this.autoFocus = true,
    this.initialQuery,
  });

  @override
  State<CommunitySearchPage> createState() => _CommunitySearchPageState();
}

class _CommunitySearchPageState extends State<CommunitySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final appConfigService = getIt<AppConfigService>();
  final postService = getIt<ApiPostService>();

  List<PostPageItemResponse> searchResults = [];
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // 初始化搜索框文本
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _handleSearch(widget.initialQuery!);
    } else {
      // 在页面初始化后自动聚焦到搜索框
      if (widget.autoFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_searchFocusNode);
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
      searchResults = [];
    });

    try {
      // 解析搜索查询
      String? tag;
      String searchQuery = query;

      // 提取第一个 #xxx 作为 tag
      final words = query.split(' ');
      for (final word in words) {
        if (word.startsWith('#')) {
          tag = word.substring(1); // 移除 #
          // 移除 tag 后的剩余查询内容
          searchQuery = query.replaceFirst(word, '').trim();
          break;
        }
      }

      // 创建搜索请求
      final request = PostSearchRequest(
        query: searchQuery,
        tag: tag,
        page: 1,
        pageSize: 20,
      );

      // 调用 API 执行搜索
      final response = await postService.searchPosts(request);

      if (response.success && response.data != null) {
        setState(() {
          searchResults = response.data!.items;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = response.message ?? '搜索失败';
        });
      }
    } catch (e) {
      if (context.mounted) {
        setState(() {
          hasError = true;
          errorMessage = '搜索过程中发生错误: $e';
        });
      }
    } finally {
      if (context.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = isLoading
        ? const Center(child: CircularProgressIndicator())
        : hasError
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage ?? '搜索失败',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _handleSearch(_searchController.text);
                      }
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          )
        : searchResults.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '没有找到相关内容',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '请尝试其他关键词或标签',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final post = searchResults[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () {
                    // 跳转到帖子详情页
                    PostViewer.show(context, post);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题
                        Text(
                          post.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // 内容摘要
                        Text(
                          post.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        // 标签
                        if (post.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: post.tags.map((tag) {
                              return Chip(
                                label: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                        ],
                        // 底部信息
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 作者信息
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                    post.uploader.avatarUrl,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  post.uploader.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            // 统计信息
                            Row(
                              children: [
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  post.viewCount.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.thumb_up_outlined,
                                  size: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  post.likeCount.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("搜索"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: '搜索社区内容',
              leading: const Icon(Icons.search),
              onChanged: (value) {
                // 搜索内容变化时的处理
              },
              onSubmitted: (value) {
                _handleSearch(value);
              },
              onTap: () {
                // Handle tap event
              },
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                    splashRadius: 18,
                  ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: appConfigService.animationTime),
              curve: Curves.easeOutQuart,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
