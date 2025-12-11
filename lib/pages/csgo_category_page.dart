import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/csgo_category_create.dart';
import 'package:southern_money/pages/csgo_products_by_category.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/router_utils.dart';
import 'package:southern_money/widgets/category_card.dart';

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
  List<CategoryResponse> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  static const _excludedCategoryIds = {
    FUTURES_CATEGORY,
    GOLD_CATEGORY,
    VIRTUAL_CATEGORY,
  };
  

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
          _categories = response.data!
              .where((category) => !_excludedCategoryIds.contains(category.id))
              .toList();
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
        // 获取搜索结果中的分类名称
        final searchNames = response.data!.categories;

        // 根据名称从完整分类列表中找到对应的分类对象
        final matchedCategories = _categories
            .where((category) => searchNames.contains(category.name))
            .toList();

        setState(() {
          _searchResults = matchedCategories;
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
        final category = _searchResults[index];
        return CategoryCard(
          category: category,
          onTap: () => _handleCategoryTap(category),
          onFavoriteToggle: () => _toggleFavorite(category),
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
        return CategoryCard(
          category: category,
          onTap: () => _handleCategoryTap(category),
          onFavoriteToggle: () => _toggleFavorite(category),
        );
      },
    );
  }

  void _handleCategoryTap(CategoryResponse category) {
    // 导航到产品列表页面
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CsgoProductsByCategory(category: category),
      ),
    );
  }

  Future<void> _toggleFavorite(CategoryResponse category) async {
    try {
      // 直接使用 category 对象中的 isFavorited 属性
      final isCurrentlyFavorited = category.isFavorited;

      if (isCurrentlyFavorited) {
        // 取消收藏
        final response = await storeApi.unfavoriteCategory(category.id);
        if (response.success) {
          setState(() {
            category.isFavorited = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('已取消收藏')));
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.message ?? '取消收藏失败')),
            );
          }
        }
      } else {
        // 添加收藏
        final response = await storeApi.favoriteCategory(category.id);
        if (response.success) {
          setState(() {
            category.isFavorited = true;
          });
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('收藏成功')));
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(response.message ?? '收藏失败')));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('操作失败: $e')));
      }
    }
  }
}
