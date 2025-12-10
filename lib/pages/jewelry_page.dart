import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/setting/app_config.dart';

import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/api_user.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

import '../widgets/dialog.dart';
import 'jewelry_category_dialog.dart';
import 'jewelry_publish_dialog.dart';

enum JewelryCategoryType {
  rifle("步枪"),
  pistol("手枪"),
  knife("刀具"),
  glove("手套");

  final String label;
  const JewelryCategoryType(this.label);
}

class JewelryPage extends StatefulWidget {
  const JewelryPage({super.key});

  @override
  State<JewelryPage> createState() => _JewelryPageState();
}

class _JewelryPageState extends State<JewelryPage> {
  final storeApi = getIt<ApiStoreService>();
  final imageApi = getIt<ApiImageService>();
  final userService = getIt<ApiUserService>();
  final cfg = getIt<AppConfigService>();

  bool openFilter = false;
  Set<JewelryCategoryType> selectedFilter = {};

  List<CategoryResponse> categories = [];
  List<ProductResponse> allProducts = [];
  UserProfileResponse? currentUser;

  int page = 1;
  final int pageSize = 20;
  bool loading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadCategories();
    _loadFirstPage();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final response = await userService.getUserProfile();
      if (response.success && response.data != null) {
        setState(() {
          currentUser = response.data!;
        });
        print("当前用户信息: ${currentUser!.name}, 管理员: ${currentUser!.isAdmin}");
      } else {
        print("获取用户信息失败: ${response.message}");
      }
    } catch (e) {
      print("获取用户信息异常: $e");
    }
  }

  Future<void> _loadCategories() async {
    print("开始加载分类数据...");
    setState(() {
      loading = true;
    });
    try {
      final res = await storeApi.getCategoryList();
      print("分类数据响应: success=${res.success}, data=${res.data}");
      
      if (res.success && res.data != null) {
        final categories = res.data!;
        print("获取到 ${categories.length} 个分类");
        
        setState(() => this.categories = categories);
        // 添加调试信息
        if (categories.isEmpty && mounted) {
          showInfoDialog(
            title: "提示", 
            content: "当前没有分类数据，请先创建分类"
          );
        }
      } else {
        print("加载分类失败: ${res.message}");
        // 添加错误提示
        if (mounted) {
          showInfoDialog(
            title: "加载失败", 
            content: res.message ?? "无法加载分类列表"
          );
        }
      }
    } catch (e, stackTrace) {
      print("加载分类异常: $e");
      print("堆栈: $stackTrace");
      if (mounted) {
        showInfoDialog(
          title: "加载失败", 
          content: e.toString()
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      loading = true;
    });
    page = 1;
    hasMore = true;
    allProducts.clear();
    await _loadPage(reset: true);
  }

  Future<void> _loadPage({required bool reset}) async {
    print("开始加载第 $page 页商品数据，重置：$reset");
    if (loading) return;
    setState(() => loading = true);

    try {
      final res = await storeApi.getProductList(page: page, pageSize: pageSize);
      print("商品数据响应: success=${res.success}, data=${res.data}");

    if (res.success && res.data != null) {
      final data = res.data!;
      print("获取到 ${data.items.length} 个商品");
      print("商品详情:");
      for (var product in data.items) {
        print("  - ${product.name} (ID: ${product.id}, 分类: ${product.categoryName}, 价格: ${product.price})");
      }
      
      setState(() {
        if (reset) {
          allProducts = data.items;
        } else {
          allProducts.addAll(data.items);
        }

        hasMore = allProducts.length < (data.totalCount ?? allProducts.length);
      });
      
      print("更新后的商品总数: ${allProducts.length}");
      
      // 添加调试信息
      if (allProducts.isEmpty && mounted) {
        showInfoDialog(
          title: "提示", 
          content: "当前没有商品数据"
        );
      }
    } else {
      print("加载商品失败: ${res.message}");
      // 添加错误提示
      if (mounted) {
        showInfoDialog(
          title: "加载失败", 
          content: res.message ?? "无法加载商品列表"
        );
      }
    }

    } catch (e, stackTrace) {
      print("商品数据加载异常: $e");
      print("异常堆栈: $stackTrace");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (!hasMore || loading) return;
    page++;
    await _loadPage(reset: false);
  }

  // ----------------- 前端过滤 -----------------
  List<ProductResponse> get filteredProducts {
    if (selectedFilter.isEmpty) return allProducts;

    final labels = selectedFilter.map((e) => e.label).toList();

    return allProducts.where((p) {
      return labels.any((label) => p.categoryName.contains(label));
    }).toList();
  }

  CategoryResponse? findCategory(ProductResponse p) {
    return categories.firstWhere(
      (c) => c.id == p.categoryId,
      orElse: () => CategoryResponse(
        id: "",
        name: p.categoryName,
        coverImageId: "",
        CreateTime: DateTime.now(),
      ),
    );
  }

  // ---------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    final products = filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '珠宝首饰',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                // 刷新按钮
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        print("手动刷新数据...");
                        _loadCategories();
                        _loadFirstPage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '刷新',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 发布商品按钮
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        if (categories.isEmpty) {
                          showInfoDialog(title: "错误", content: "尚未创建主分类");
                          return;
                        }
                        final ok = await JewelryPublishDialog.show(context, categories);
                        if (ok == true) _loadFirstPage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '发布',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 创建分类按钮（管理员）
                if (currentUser?.isAdmin == true)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          if (currentUser == null) {
                            showInfoDialog(title: "错误", content: "请先登录");
                            return;
                          }
                          if (!currentUser!.isAdmin) {
                            showInfoDialog(title: "权限不足", content: "只有管理员可以创建分类");
                            return;
                          }
                          final ok = await JewelryCategoryDialog.show(context);
                          if (ok == true) _loadCategories();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                color: Colors.grey[700],
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '分类',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                // 筛选按钮
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => setState(() => openFilter = !openFilter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list_outlined,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '筛选',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '搜索CSGO饰品...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onSubmitted: (_) => _loadFirstPage(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CategoryResponse>(
                        value: categories.isEmpty ? null : categories.first,
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '全部分类',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        isExpanded: true,
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey[600],
                            size: 24,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem<CategoryResponse>(
                            value: category,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(category.name),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (category) {
                          setState(() {
                            // 可在此添加分类过滤逻辑
                          });
                          _loadFirstPage();
                        },
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: cfg.animationTime),
              height: openFilter ? 70 : 0,
              child: _buildFilter(),
            ),
          // 调试信息显示
          if (categories.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.withOpacity(0.1),
              child: const Text(
                '当前没有分类数据，请先创建分类',
                style: TextStyle(color: Colors.orange),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey.withOpacity(0.1),
              child: Text(
                '当前有 ${categories.length} 个分类，${filteredProducts.length} 个商品',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          Expanded(
            child: loading && allProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadFirstPage,
                    child: ListView.builder(
                      itemCount: products.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= products.length) {
                          _loadMore();
                          return const Padding(
                            padding: EdgeInsets.all(18),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = products[index];
                        final category = findCategory(item);
                        final coverUrl = (category?.coverImageId.isEmpty ?? true)
                            ? null
                            : imageApi.getImageUrl(category!.coverImageId);

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.grey.withOpacity(0.05),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                // TODO: 跳转到商品详情页
                                print("点击商品: ${item.name}");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: "product_${item.id}",
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.grey.withOpacity(0.1),
                                        ),
                                        child: coverUrl == null
                                            ? Icon(
                                                Icons.inventory_2_outlined,
                                                size: 40,
                                                color: Colors.grey[400],
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.network(
                                                  coverUrl,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        color: Colors.grey.withOpacity(0.1),
                                                      ),
                                                      child: Icon(
                                                        Icons.broken_image_outlined,
                                                        size: 40,
                                                        color: Colors.grey[400],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              height: 1.2,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              item.categoryName,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                item.uploaderName,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(
                                                Icons.access_time_outlined,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _formatTimeAgo(item.CreateTime),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.orange.shade400,
                                                Colors.orange.shade600,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange.withOpacity(0.2),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "￥${item.price.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------- Build Filter -----------------

  Widget _buildFilter() {
    return Center(
      child: SegmentedButton<JewelryCategoryType>(
        segments: const [
          ButtonSegment(value: JewelryCategoryType.rifle, label: Text("步枪")),
          ButtonSegment(value: JewelryCategoryType.pistol, label: Text("手枪")),
          ButtonSegment(value: JewelryCategoryType.knife, label: Text("刀具")),
          ButtonSegment(value: JewelryCategoryType.glove, label: Text("手套")),
        ],
        multiSelectionEnabled: true,
        emptySelectionAllowed: true,
        selected: selectedFilter,
        onSelectionChanged: (set) {
          setState(() => selectedFilter = set);
        },
      ),
    );
  }
}
