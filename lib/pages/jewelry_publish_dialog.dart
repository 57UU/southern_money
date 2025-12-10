import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/dialog.dart';

class JewelryPublishDialog extends StatefulWidget {
  final List<CategoryResponse> categories;

  const JewelryPublishDialog({
    super.key,
    required this.categories,
  });

  /// 外部调用：`final ok = await JewelryPublishDialog.show(context, categories);`
  static Future<bool?> show(
    BuildContext context,
    List<CategoryResponse> categories,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (_) => JewelryPublishDialog(categories: categories),
    );
  }

  @override
  State<JewelryPublishDialog> createState() => _JewelryPublishDialogState();
}

class _JewelryPublishDialogState extends State<JewelryPublishDialog> {
  final storeApi = getIt<ApiStoreService>();
  final imageApi = getIt<ApiImageService>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  late CategoryResponse _selectedCategory;

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final res = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (res != null) {
      setState(() => _pickedImage = res);
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final priceText = _priceController.text.trim();
    final desc = _descController.text.trim();

    print("开始提交商品: name=$name, priceText=$priceText, desc=$desc");

    if (name.isEmpty || priceText.isEmpty || desc.isEmpty) {
      showInfoDialog(title: "错误", content: "请填写完整信息");
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      showInfoDialog(title: "错误", content: "请输入正确的价格");
      return;
    }

    if (_submitting) return;
    _submitting = true;

    // 商品图片（和分类封面是两码事）
    String? productImageId;

    if (_pickedImage != null) {
      print("开始上传商品图片...");
      ApiResponse<ImageUploadResponse> res;
      try {
        if (kIsWeb) {
          print("Web平台上传图片，路径: ${_pickedImage!.path}");
          res = await imageApi.uploadImageWeb(
            imagePath: _pickedImage!.path,
            imageType: "product",
          );
        } else {
          print("非Web平台上传图片，路径: ${_pickedImage!.path}");
          res = await imageApi.uploadImage(
            imageFile: File(_pickedImage!.path),
            imageType: "product",
          );
        }
        print("图片上传结果: success=${res.success}, message=${res.message}, data=${res.data}");

        if (!res.success || res.data == null) {
          _submitting = false;
          showInfoDialog(title: "错误", content: "商品图片上传失败：${res.message}");
          return;
        }

        productImageId = res.data!.imageId;
        print("图片上传成功，imageId: $productImageId");
      } catch (e) {
        print("图片上传异常: $e");
        _submitting = false;
        showInfoDialog(title: "错误", content: "图片上传异常：$e");
        return;
      }
      // ⚠️ API.md 没有"商品图片绑定"的字段，这里只是拿到图片 ID，
      // 若以后你在后端给 Product 增加 ImageIds，再扩展接口即可。
    } else {
      print("没有选择商品图片");
    }

    print("开始发布商品，参数: name=$name, price=$price, categoryId=${_selectedCategory.id}");
    
    try {
      await showLoadingDialog(
        title: "正在发布商品",
        func: () async {
          final response = await storeApi.publishProduct(
            name: name,
            price: price,
            description: desc +
                (productImageId != null ? "\n[ImageId:$productImageId]" : ""),
            categoryId: _selectedCategory.id,
          );
          print("商品发布结果: success=${response.success}, message=${response.message}");
          
          if (!response.success) {
            throw Exception(response.message ?? "发布商品失败");
          }
        },
      );

      print("商品发布完成");
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print("商品发布异常: $e");
      _submitting = false;
      if (mounted) {
        showInfoDialog(title: "错误", content: "商品发布失败：$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text("发布饰品"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 名称
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "商品名称",
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 12),

            // 价格
            TextField(
              controller: _priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "价格 (￥)",
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 12),

            // 描述
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "描述",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),

            // 选择分类
            DropdownButtonFormField<CategoryResponse>(
              value: _selectedCategory,
              items: widget.categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.name),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _selectedCategory = v);
                }
              },
              decoration: const InputDecoration(labelText: "所属分类"),
            ),
            const SizedBox(height: 16),

            // 图片
            if (_pickedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? Image.network(
                        _pickedImage!.path,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_pickedImage!.path),
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
              ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: Text(_pickedImage == null ? "选择商品图片" : "重新选择商品图片"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
          child: const Text("取消"),
        ),
        TextButton(
          onPressed: _submitting ? null : _submit,
          child: const Text("发布"),
        ),
      ],
    );
  }
}
