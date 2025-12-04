import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/dialog.dart';

/// 前端筛选用
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
  bool openFilter = false;
  final appConfigService = getIt<AppConfigService>();
  final storeApi = getIt<ApiStoreService>();
  final imageApi = getIt<ApiImageService>();

  List<CategoryResponse> _categories = [];
  List<ProductResponse> _allProducts = [];

  // 分页
  int _page = 1;
  final int _pageSize = 20;
  bool _loading = false;
  bool _hasMore = true;

  Set<JewelryCategory> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadFirstPage();
  }

  // ==================== 分类 ==========================
  Future<void> _loadCategories() async {
    final res = await storeApi.getCategoryList();
    if (res.success && res.data != null) {
      setState(() => _categories = res.data!);
    }
  }

  // ==================== 商品列表 =======================
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
    setState(() => _loading = true);

    final res = await storeApi.getProductList(
      page: _page,
      pageSize: _pageSize,
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

    setState(() => _loading = false);
  }

  // ======================== 前端筛选 ========================
  List<ProductResponse> get _filteredProducts {
    if (_selectedCategories.isEmpty) return _allProducts;
    final labels = _selectedCategories.map((e) => e.label).toList();

    return _allProducts.where((p) {
      return labels.any((label) => p.categoryName.contains(label));
    }).toList();
  }

  CategoryResponse _findCategory(ProductResponse p) {
    return _categories.firstWhere(
      (c) => c.id == p.categoryId,
      orElse: () => CategoryResponse(
        id: "",
        name: p.categoryName,
        coverImageId: "",
        createdAt: DateTime.now(),
      ),
    );
  }

  // ======================= 发布商品 + 上传图片 ========================
  Future<void> _showPublishDialog() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();

    if (_categories.isEmpty) {
      await showInfoDialog(
        title: "提示",
        content: "尚未创建任何分类，请先添加分类。",
      );
      return;
    }

    CategoryResponse selectedCategory = _categories.first;

    File? pickedImage;
    String? uploadedImageId;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text("发布商品"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "名称"),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: "价格"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: "描述"),
                    ),
                    const SizedBox(height: 12),

                    // 分类选择
                    DropdownButtonFormField<CategoryResponse>(
                      value: selectedCategory,
                      items: _categories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.name),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() {
                            selectedCategory = v;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: "分类"),
                    ),

                    const SizedBox(height: 12),

                    // 图片预览
                    if (pickedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          pickedImage!,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),

                    TextButton.icon(
                      icon: const Icon(Icons.image),
                      label: Text(pickedImage == null ? "选择封面图片" : "重新选择"),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final res =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (res != null) {
                          pickedImage = File(res.path);
                          setDialogState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("取消"),
                ),
                TextButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final price =
                        double.tryParse(priceController.text.trim());
                    final desc = descController.text.trim();

                    if (name.isEmpty || desc.isEmpty || price == null) {
                      showInfoDialog(
                        title: "提示",
                        content: "请输入完整信息！",
                      );
                      return;
                    }

                    // ------------ 如果选择了图片，则上传 ------------
                    if (pickedImage != null) {
                      final uploadRes = await imageApi.uploadImage(
                        imageFile: pickedImage!,
                        imageType: "categoryCover",
                      );

                      if (uploadRes.success && uploadRes.data != null) {
                        uploadedImageId = uploadRes.data!.imageId;

                        // -------- 自动更新分类封面 --------
                        await getIt<JwtDio>().post(
                          "/store/category/updateCover",
                          data: {
                            "CategoryId": selectedCategory.id,
                            "ImageId": uploadedImageId
                          },
                        );

                        // 重新加载分类（拿到新的 CoverImageId）
                        await _loadCategories();
                      }
                    }

                    // ------------ 发布商品 ------------
                    await showLoadingDialog(
                      title: "正在发布",
                      func: () async {
                        await storeApi.publishProduct(
                          name: name,
                          price: price,
                          description: desc,
                          categoryId: selectedCategory.id,
                        );
                      },
                    );

                    if (ctx.mounted) Navigator.pop(ctx);

                    // 刷新商品列表
                    await _loadFirstPage();

                    await showInfoDialog(
                      title: "成功",
                      content: "商品发布成功！",
                    );
                  },
                  child: const Text("发布"),
                )
              ],
            );
          },
        );
      },
    );
  }

  // ========================= 购买商品 ==========================
  Future<void> _buy(ProductResponse item) async {
    bool ok = true;

    await showLoadingDialog(
      title: "正在购买",
      func: () async {
        try {
          await getIt<JwtDio>().post(
            "/transaction/buy",
            data: {"ProductId": item.id},
          );
        } catch (e) {
          ok = false;
          rethrow;
        }
      },
    );

    if (!ok) {
      showInfoDialog(title: "购买失败", content: "请稍后再试");
      return;
    }

    showInfoDialog(title: "购买成功", content: "已购买 ${item.name}");
  }

  // ========================== UI ================================

  @override
  Widget build(BuildContext context) {
    final cfg = appConfigService;
    final products = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("CSGO饰品"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "发布商品",
            onPressed: _showPublishDialog,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => setState(() => openFilter = !openFilter),
          ),
        ],
      ),
      body: Column(
        children: [
          // 筛选区域
          AnimatedContainer(
            duration: Duration(milliseconds: cfg.animationTime),
            height: openFilter ? 200 : 0,
            child: JewelryFilter(
              selected: _selectedCategories,
              onChanged: (set) {
                setState(() => _selectedCategories = set);
              },
            ),
          ),

          // 列表
          Expanded(
            child: _loading && _allProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadFirstPage,
                    child: ListView.builder(
                      itemCount: products.length + (_hasMore ? 1 : 0),
                      itemBuilder: (ctx, i) {
                        if (i >= products.length) {
                          _loadMore();
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ));
                        }

                        final item = products[i];
                        final cat = _findCategory(item);

                        final imageUrl = cat.coverImageId.isEmpty
                            ? null
                            : "${cfg.baseUrl}${imageApi.getImageUrl(cat.coverImageId)}";

                        return ListTile(
                          leading: imageUrl == null
                              ? const Icon(Icons.image)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          title: Text(item.name),
                          subtitle:
                              Text("${item.categoryName}  ￥${item.price}"),
                          trailing: TextButton(
                            child: const Text("购买"),
                            onPressed: () => _buy(item),
                          ),
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

// --------------------- 筛选器组件 -----------------------

class JewelryFilter extends StatefulWidget {
  final Set<JewelryCategory> selected;
  final ValueChanged<Set<JewelryCategory>> onChanged;

  const JewelryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<JewelryFilter> createState() => _JewelryFilterState();
}

class _JewelryFilterState extends State<JewelryFilter> {
  late Set<JewelryCategory> selected;

  @override
  void initState() {
    super.initState();
    selected = {...widget.selected};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        children: [
          const SizedBox(height: 16),
          SegmentedButton<JewelryCategory>(
            segments: const [
              ButtonSegment(
                value: JewelryCategory.rifle,
                label: Text("步枪"),
              ),
              ButtonSegment(
                value: JewelryCategory.pistol,
                label: Text("手枪"),
              ),
              ButtonSegment(
                value: JewelryCategory.knife,
                label: Text("刀具"),
              ),
              ButtonSegment(
                value: JewelryCategory.glove,
                label: Text("手套"),
              ),
            ],
            selected: selected,
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            onSelectionChanged: (Set<JewelryCategory> set) {
              setState(() => selected = set);
              widget.onChanged(selected);
            },
          ),
        ],
      ),
    );
  }
}
