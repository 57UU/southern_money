import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

import 'jewelry_filter.dart';
import 'jewelry_create_category.dart';  // ← 使用新弹窗文件

enum JewelryCategory {
  rifle('步枪'),
  pistol('手枪'),
  knife('刀具'),
  glove('手套');

  final String label;
  const JewelryCategory(this.label);
}

class JewelryPage extends StatefulWidget {
  const JewelryPage({super.key});

  @override
  State<JewelryPage> createState() => _JewelryPageState();
}

class _JewelryPageState extends State<JewelryPage> {
  final cfg = getIt<AppConfigService>();
  final storeApi = getIt<ApiStoreService>();
  final imageApi = getIt<ApiImageService>();

  bool openFilter = false;
  List<CategoryResponse> categories = [];
  List<ProductResponse> products = [];

  int page = 1;
  final int pageSize = 20;
  bool loading = false;
  bool hasMore = true;

  Set<JewelryCategory> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadFirstPage();
  }

  Future<void> _loadCategories() async {
    final res = await storeApi.getCategoryList();
    if (res.success && res.data != null) {
      setState(() => categories = res.data!);
    }
  }

  Future<void> _loadFirstPage() async {
    page = 1;
    hasMore = true;
    products = [];
    await _loadPage(reset: true);
  }

  Future<void> _loadPage({required bool reset}) async {
    setState(() => loading = true);

    final res = await storeApi.getProductList(page: page, pageSize: pageSize);
    if (res.success && res.data != null) {
      setState(() {
        if (reset) products = res.data!.items;
        else products.addAll(res.data!.items);

        final total = res.data!.totalCount ?? products.length;
        hasMore = products.length < total;
      });
    }

    setState(() => loading = false);
  }

  Future<void> _loadMore() async {
    if (!hasMore || loading) return;
    page++;
    await _loadPage(reset: false);
  }

  List<ProductResponse> get filteredProducts {
    if (selectedCategories.isEmpty) return products;

    final labels = selectedCategories.map((e) => e.label).toList();
    return products.where((p) {
      return labels.any((lbl) => p.categoryName.contains(lbl));
    }).toList();
  }

  CategoryResponse findCategory(ProductResponse p) {
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

  @override
  Widget build(BuildContext context) {
    final filtered = filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("CSGO 饰品"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "创建饰品",
            onPressed: () async {
              await showCreateItemDialog(context, categories);
              await _loadFirstPage(); // 刷新
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: "筛选",
            onPressed: () => setState(() => openFilter = !openFilter),
          ),
        ],
      ),

      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: openFilter ? 200 : 0,
            child: JewelryFilter(
              selected: selectedCategories,
              onChanged: (v) => setState(() => selectedCategories = v),
            ),
          ),

          Expanded(
            child: loading && products.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadFirstPage,
                    child: ListView.builder(
                      itemCount: filtered.length + (hasMore ? 1 : 0),
                      itemBuilder: (ctx, i) {
                        if (i >= filtered.length) {
                          _loadMore();
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = filtered[i];
                        final cat = findCategory(item);

                        final imgUrl = cat.coverImageId.isEmpty
                            ? null
                            : "${cfg.baseUrl}${imageApi.getImageUrl(cat.coverImageId)}";

                        return ListTile(
                          leading: imgUrl == null
                              ? const Icon(Icons.image)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imgUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          title: Text(item.name),
                          subtitle: Text("${item.categoryName}  ￥${item.price}"),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
