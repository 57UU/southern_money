import 'package:flutter/material.dart';
import 'package:southern_money/pages/csgo_category_create.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/router_utils.dart';

class CsgoCategoryPage extends StatefulWidget {
  const CsgoCategoryPage({super.key});

  @override
  State<CsgoCategoryPage> createState() => _CsgoCategoryPageState();
}

class _CsgoCategoryPageState extends State<CsgoCategoryPage> {
  final storeApi = getIt<ApiStoreService>();
  final apiImageService = getIt<ApiImageService>();
  final TextEditingController _searchController = TextEditingController();
  List<CategoryResponse> _categories = [];
  List<String> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    } else {
      _searchCategories(_searchController.text);
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await storeApi.getCategoryList();
      if (response.success && response.data != null) {
        setState(() {
          _categories = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.message ?? '加载分类失败')));
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载分类失败: $e')));
      }
    }
  }

  Future<void> _searchCategories(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final response = await storeApi.searchCategories(query);
      if (response.success && response.data != null) {
        setState(() {
          _searchResults = response.data!.categories;
          _isSearching = false;
        });
      } else {
        setState(() {
          _isSearching = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.message ?? '搜索失败')));
        }
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('搜索失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSGO分类'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadCategories();
            },
            label: Text("刷新"),
          ),
          SizedBox(width: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await popupOrNavigate(
                context,
                CsgoCategoryCreate(),
              );
              if (result == true) {
                _loadCategories();
              }
            },
            label: Text("添加分类"),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索分类...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchController.text.isNotEmpty
                ? _buildSearchResults()
                : _buildCategoriesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('未找到匹配的分类'));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final categoryName = _searchResults[index];
        return ListTile(
          title: Text(categoryName),
          leading: const Icon(Icons.category),
          onTap: () {
            // 处理点击搜索结果
            _handleCategoryTap(categoryName);
          },
        );
      },
    );
  }

  Widget _buildCategoriesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_categories.isEmpty) {
      return const Center(child: Text('暂无分类'));
    }

    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                apiImageService.getImageUrl(category.coverImageId),
              ),
              onBackgroundImageError: (exception, stackTrace) {
                // 图片加载失败时的处理
              },
              child: category.coverImageId.isEmpty
                  ? const Icon(Icons.category)
                  : null,
            ),
            title: Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '创建时间: ${category.CreateTime.toString().substring(0, 10)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () {
              // 处理点击分类
              _handleCategoryTap(category.name);
            },
          ),
        );
      },
    );
  }

  void _handleCategoryTap(String categoryName) {
    // 这里可以添加点击分类后的处理逻辑
    // 例如导航到分类详情页面
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('点击了分类: $categoryName')));
  }
}
