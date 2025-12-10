import 'package:flutter/material.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/widgets/dialog.dart';

class CsgoProductDetailPage extends StatefulWidget {
  final String productId;
  final bool showDeleteButton;
  const CsgoProductDetailPage({
    super.key,
    required this.productId,
    this.showDeleteButton = false,
  });

  @override
  State<CsgoProductDetailPage> createState() => _CsgoProductDetailPageState();
}

class _CsgoProductDetailPageState extends State<CsgoProductDetailPage> {
  final apiStoreService = getIt<ApiStoreService>();
  final apiImageService = getIt<ApiImageService>();

  ProductDetailResponse? _productDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
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

    final result = await showLoadingDialogWithErrorString(
      title: "删除中",
      func: () async {
        final response = await apiStoreService.deleteProduct(
          _productDetail!.id,
        );
        if (!response.success) {
          throw Exception(response.message ?? "删除失败");
        }
        return response;
      },
      onErrorMessage: "删除产品失败，请重试",
    );

    if (result && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_productDetail?.name ?? "产品详情"),
        actions: [
          if (_productDetail != null && widget.showDeleteButton)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteProduct,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProductDetail,
                child: const Text("重试"),
              ),
            ],
          ),
        ),
      );
    }

    if (_productDetail == null) {
      return const Center(child: Text("未找到产品信息"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 产品名称
          Text(
            _productDetail!.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 产品价格
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  "价格: ¥${_productDetail!.price.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 产品分类
          Row(
            children: [
              const Icon(Icons.category, size: 20),
              const SizedBox(width: 8),
              Text(
                "分类: ${_productDetail!.categoryName}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 上传者信息
          if (_productDetail!.uploader != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: _productDetail!.uploader!.avatar != null
                        ? NetworkImage(
                            apiImageService.getImageUrl(
                              _productDetail!.uploader!.avatar!,
                            ),
                          )
                        : null,
                    child: _productDetail!.uploader!.avatar == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // 上传者信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "上传者: ${_productDetail!.uploader!.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "ID: ${_productDetail!.uploader!.id}",
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
            ),
            const SizedBox(height: 16),
          ] else if (_productDetail!.uploaderName != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    "上传者: ${_productDetail!.uploaderName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 创建时间
          if (_productDetail!.CreateTime != null) ...[
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text(
                  "发布时间: ${_formatDateTime(_productDetail!.CreateTime!)}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // 产品描述
          const Text(
            "产品描述",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _productDetail!.description.isEmpty
                  ? "暂无描述"
                  : _productDetail!.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
