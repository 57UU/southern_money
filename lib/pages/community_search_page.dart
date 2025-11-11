import 'package:flutter/material.dart';
import '../setting/app_config.dart';

class CommunitySearchPage extends StatefulWidget {
  const CommunitySearchPage({super.key});

  @override
  State<CommunitySearchPage> createState() => _CommunitySearchPageState();
}

class _CommunitySearchPageState extends State<CommunitySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 在页面初始化后自动聚焦到搜索框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    // 处理搜索逻辑
    print('搜索: $query');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: SearchBar(
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              '取消',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: animationTime),
        curve: Curves.easeOutQuart,
        child: Center(
          child: Text(
            '请输入关键词搜索',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
