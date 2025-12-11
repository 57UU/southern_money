import 'package:flutter/material.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/widgets/dialog.dart';

class CsgoProductDetailPage extends StatefulWidget {
  final String productId;
  final ProductDetailResponse? productDetail;
  const CsgoProductDetailPage({
    super.key,
    required this.productId,
    this.productDetail,
  });

  @override
  State<CsgoProductDetailPage> createState() => _CsgoProductDetailPageState();
}

class _CsgoProductDetailPageState extends State<CsgoProductDetailPage> {
  final apiStoreService = getIt<ApiStoreService>();
  final apiImageService = getIt<ApiImageService>();
  final tokenService = getIt<TokenService>();

  ProductDetailResponse? _productDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.productDetail != null) {
      _productDetail = widget.productDetail;
      setState(() {
        _isLoading = false;
      });
    }
    _loadProductDetail();
  }

  Future<void> _loadProductDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await apiStoreService.getProductDetail(widget.productId);

      if (response.success && response.data != null) {
        setState(() {
          _productDetail = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? "获取产品详情失败";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "获取产品详情时发生错误: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct() async {
    if (_productDetail == null) return;

    final confirm = await showYesNoDialog(
      title: "确认删除",
      content: "确定要删除产品「${_productDetail!.name}」吗？此操作不可撤销。",
    );

    if (confirm != true) return;

    final result = await apiRequestDialog(() async {
      final response = await apiStoreService.deleteProduct(_productDetail!.id);
      if (!response.success) {
        throw Exception(response.message ?? "删除失败");
      }
      return response;
    }());

    if (result == true && mounted) {
      popDialog(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_productDetail?.name ?? "产品详情")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("加载产品详情中..."),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadProductDetail,
                icon: const Icon(Icons.refresh),
                label: const Text("重试"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_productDetail == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("未找到产品信息", style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 产品名称卡片
          _buildProductInfoCard(),
          const SizedBox(height: 16),

          // 价格卡片
          _buildPriceCard(),
          const SizedBox(height: 16),

          // 产品描述卡片
          _buildDescriptionCard(),

          // 分类和时间信息卡片
          _buildCategoryAndTimeCard(),
          const SizedBox(height: 16),

          // 上传者信息卡片
          _buildUploaderCard(),
          const SizedBox(height: 16),

          // 购买按钮卡片
          if (_productDetail != null &&
              _productDetail!.uploader.id != tokenService.id) _buildBuyCard(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2_outlined, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _productDetail!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (_productDetail != null &&
                    _productDetail!.uploader.id == tokenService.id)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteProduct,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "价格",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "¥${_productDetail!.price.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryAndTimeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 分类信息
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.category,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "分类",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        _productDetail!.categoryName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 时间信息
            if (_productDetail!.CreateTime != null)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "发布时间",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          _formatDateTime(_productDetail!.CreateTime!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploaderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.purple.shade700, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "上传者信息",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.purple.shade100,
                  backgroundImage: NetworkImage(_productDetail!.avatarUrl),
                  child: null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _productDetail!.uploader.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ID: ${_productDetail!.uploader.id}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "产品描述",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                _productDetail!.description.isEmpty
                    ? "暂无描述"
                    : _productDetail!.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _buyProduct() async {
    if (_productDetail == null) return;

    final confirm = await showYesNoDialog(
      title: "确认购买",
      content: "确定要以 ¥${_productDetail!.price.toStringAsFixed(2)} 的价格购买产品「${_productDetail!.name}」吗？",
    );

    if (confirm != true) return;

    final result = await apiRequestDialog(() async {
      final response = await apiStoreService.buyProduct(
        productId: _productDetail!.id,
      );
      if (!response.success) {
        throw Exception(response.message ?? "购买失败");
      }
      return response;
    }());

    if (result == true && mounted) {
      // 购买成功，返回上一页
      Navigator.pop(context, true);
    }
  }

  Widget _buildBuyCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "确认购买",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "您将以 ¥${_productDetail!.price.toStringAsFixed(2)} 的价格购买此产品",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _buyProduct,
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text(
                  "立即购买",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
