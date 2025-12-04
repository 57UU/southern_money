import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class JewelryPage extends StatefulWidget {
  const JewelryPage({super.key});

  @override
  State<JewelryPage> createState() => _JewelryPageState();
}

class _JewelryPageState extends State<JewelryPage> {
  bool openFilter = false;
  final appConfigService = getIt<AppConfigService>();
  final storeApi = getIt<ApiStoreService>();

  // 后端返回的所有商品
  List<ProductResponse> _allProducts = [];

  // 当前页 / 分页状态
  int _page = 1;
  final int _pageSize = 20;
  bool _loading = false;
  bool _hasMore = true;

  // 当前选中的过滤类型
  Set<JewelryCategory> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    _page = 1;
    _hasMore = true;
    _allProducts = [];
    await _loadPage(reset: true);
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _loading) return;
    _page++;
    await _loadPage(reset: false);
  }

  Future<void> _loadPage({required bool reset}) async {
    setState(() {
      _loading = true;
    });

    final res = await storeApi.getProductList(
      page: _page,
      pageSize: _pageSize,
      // 这里暂时不按 categoryId / search 过滤，全部拿回来再在前端过滤
      categoryId: null,
      search: null,
    );

    if (res.success && res.data != null) {
      final data = res.data!;
      setState(() {
        if (reset) {
          _allProducts = data.items;
        } else {
          _allProducts.addAll(data.items);
        }
        final total = data.totalCount ?? _allProducts.length;
        _hasMore = _allProducts.length < total;
      });
    }

    setState(() {
      _loading = false;
    });
  }

  // 根据筛选器在前端过滤
  List<ProductResponse> get _filteredProducts {
    if (_selectedCategories.isEmpty) return _allProducts;
    final labels = _selectedCategories.map((e) => e.label).toList();
    return _allProducts.where((p) {
      return labels.any((label) => p.categoryName.contains(label));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CSGO饰品'),
        actions: [
          Row(
            children: [
              const Text('筛选器'),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  setState(() {
                    openFilter = !openFilter;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 顶部过滤器区域
          AnimatedContainer(
            duration: Duration(milliseconds: appConfigService.animationTime),
            curve: Curves.easeOutQuart,
            height: openFilter ? 200 : 0,
            child: SingleChildScrollView(
              physics: openFilter
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: JewelryFilter(
                selectedCategories: _selectedCategories,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedCategories = newSelection;
                  });
                },
              ),
            ),
          ),

          // 下方列表区域
          Expanded(
            child: _loading && _allProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadFirstPage,
                    child: ListView.builder(
                      itemCount: products.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= products.length) {
                          // 底部加载更多
                          _loadMore();
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = products[index];
                        return ListTile(
                          leading: const Icon(Icons.shopping_bag),
                          title: Text(item.name),
                          subtitle: Text(
                            "${item.categoryName}  ￥${item.price.toStringAsFixed(2)}",
                          ),
                          onTap: () {
                            // TODO: 后面可以加详情页
                          },
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

// ---------------- 下面是筛选器部分（在你原来的基础上改了一点） ----------------

class JewelryFilter extends StatefulWidget {
  final Set<JewelryCategory> selectedCategories;
  final ValueChanged<Set<JewelryCategory>> onSelectionChanged;

  const JewelryFilter({
    super.key,
    required this.selectedCategories,
    required this.onSelectionChanged,
  });

  @override
  State<JewelryFilter> createState() => _JewelryFilterState();
}

// 定义饰品类型枚举
enum JewelryCategory {
  rifle('步枪'),
  pistol('手枪'),
  knife('刀具'),
  glove('手套'),
  helmet('头盔');

  final String label;
  const JewelryCategory(this.label);
}

class _JewelryFilterState extends State<JewelryFilter> {
  late Set<JewelryCategory> selectedCategories;

  @override
  void initState() {
    super.initState();
    selectedCategories = {...widget.selectedCategories};
  }

  void applyFilter() {
    // 当前示例仅在前端过滤，因此只需要通知父组件
    widget.onSelectionChanged(selectedCategories);
    // 你可以在这里加 SnackBar 或别的提示
  }

  void cancelFilter() {
    setState(() {
      selectedCategories.clear();
    });
    widget.onSelectionChanged(selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final segmentButtons = SegmentedButton<JewelryCategory>(
      segments: const <ButtonSegment<JewelryCategory>>[
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.rifle,
          label: Text('步枪'),
        ),
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.pistol,
          label: Text('手枪'),
        ),
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.knife,
          label: Text('刀具'),
        ),
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.glove,
          label: Text('手套'),
        ),
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.helmet,
          label: Text('头盔'),
        ),
      ],
      selected: selectedCategories,
      onSelectionChanged: (Set<JewelryCategory> newSelection) {
        setState(() {
          selectedCategories = newSelection;
        });
        // 实时通知父组件也可以：
        widget.onSelectionChanged(selectedCategories);
      },
      multiSelectionEnabled: true,
      emptySelectionAllowed: true,
    );

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择饰品类型',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: segmentButtons),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: cancelFilter, child: const Text('取消')),
              ElevatedButton(
                onPressed: applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: const Text('应用'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
