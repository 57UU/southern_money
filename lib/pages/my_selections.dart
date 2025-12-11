import 'dart:math';

import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/category_card.dart';
import 'package:southern_money/pages/csgo_products_by_category.dart';
import 'package:flutter/cupertino.dart';

class MySelections extends StatefulWidget {
  const MySelections({super.key});

  @override
  State<MySelections> createState() => _MySelectionsState();
}

class _MySelectionsState extends State<MySelections> {
  final storeService = getIt<ApiStoreService>();
  List<CategoryResponse> _favoriteCategories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCategories();
  }

  Future<void> _loadFavoriteCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await storeService.getFavoriteCategories();
      if (response.success && response.data != null) {
        final favorites = response.data!;
        setState(() {
          _favoriteCategories = favorites;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? '加载收藏分类失败')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载收藏分类失败: $e')));
      }
    }
  }

  Future<void> _toggleFavorite(CategoryResponse category) async {
    try {
      // 直接使用 category 对象中的 isFavorited 属性
      final isCurrentlyFavorited = category.isFavorited;

      if (isCurrentlyFavorited) {
        // 取消收藏
        final response = await storeService.unfavoriteCategory(category.id);
        if (response.success) {
          setState(() {
            category.isFavorited = false;
            _favoriteCategories.removeWhere((c) => c.id == category.id);
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
        final response = await storeService.favoriteCategory(category.id);
        if (response.success) {
          setState(() {
            category.isFavorited = true;
            _favoriteCategories.add(category);
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

  void _handleCategoryTap(CategoryResponse category) {
    // 导航到产品列表页面
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CsgoProductsByCategory(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadFavoriteCategories();
            },
            label: Text("刷新"),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteCategories.isEmpty
          ? const Center(child: Text('暂无收藏分类'))
          : ListView.builder(
              itemCount: _favoriteCategories.length,
              itemBuilder: (context, index) {
                final category = _favoriteCategories[index];
                return CategoryCard(
                  category: category,
                  onTap: () => _handleCategoryTap(category),
                  onFavoriteToggle: () => _toggleFavorite(category),
                );
              },
            ),
    );
  }
}
