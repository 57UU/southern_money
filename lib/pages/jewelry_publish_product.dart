import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/webapi/JwtService.dart';

final storeApi = getIt<ApiStoreService>();
final imageApi = getIt<ApiImageService>();
final jwt = getIt<JwtDio>();

Future<void> showPublishProductDialog(
  BuildContext context,
  List<CategoryResponse> categories,
) async {
  if (categories.isEmpty) {
    showInfoDialog(title: "错误", content: "尚未创建分类");
    return;
  }

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  CategoryResponse selectedCategory = categories.first;

  File? image;
  String? uploadedImageId;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        return AlertDialog(
          title: const Text("发布商品"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "名称")),
                TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "价格")),
                TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "描述")),

                DropdownButtonFormField(
                  value: selectedCategory,
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedCategory = v as CategoryResponse),
                ),

                const SizedBox(height: 16),

                if (image != null)
                  Image.file(image!, width: 140, height: 140, fit: BoxFit.cover),

                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: Text(image == null ? "选择商品图片" : "重新选择"),
                  onPressed: () async {
                    final pick = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pick != null) {
                      image = File(pick.path);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("取消")),
            TextButton(
              child: const Text("发布"),
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final desc = descCtrl.text.trim();
                final price = double.tryParse(priceCtrl.text.trim());

                if (name.isEmpty || desc.isEmpty || price == null) {
                  showInfoDialog(title: "错误", content: "请填写全部内容");
                  return;
                }

                if (image != null) {
                  final res = await imageApi.uploadImage(
                    imageFile: image!,
                    imageType: "product",
                  );
                  if (res.success) {
                    uploadedImageId = res.data!.imageId;
                  }
                }

                // 自动更新分类封面
                if (uploadedImageId != null) {
                  await jwt.post("/store/category/updateCover", data: {
                    "CategoryId": selectedCategory.id,
                    "ImageId": uploadedImageId
                  });
                }

                await showLoadingDialog(
                  title: "发布中",
                  func: () async {
                    await storeApi.publishProduct(
                      name: name,
                      price: price,
                      description: desc,
                      categoryId: selectedCategory.id,
                    );
                  },
                );

                Navigator.pop(ctx);
                showInfoDialog(title: "成功", content: "商品已发布！");
              },
            )
          ],
        );
      },
    ),
  );
}
