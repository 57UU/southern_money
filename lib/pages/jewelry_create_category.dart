import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'jewelry_page.dart';

final storeApiDialog = getIt<ApiStoreService>();
final imageApiDialog = getIt<ApiImageService>();
final jwtDialog = getIt<JwtDio>();

Future<void> showCreateItemDialog(
  BuildContext context,
  List<CategoryResponse> categories,
) async {
  if (categories.isEmpty) {
    showInfoDialog(title: "错误", content: "尚未创建主分类");
    return;
  }

  File? pickedImage;
  String? imageId;

  JewelryCategoryType mainType = JewelryCategoryType.rifle;

  CategoryResponse selectedBackendCategory = categories.firstWhere(
    (c) => c.name.contains("步枪"),
    orElse: () => categories.first,
  );

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        return AlertDialog(
          title: const Text("创建饰品"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<JewelryCategoryType>(
                  value: mainType,
                  items: JewelryCategoryType.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.label),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => mainType = v);

                      // 映射主类别到后端分类
                      selectedBackendCategory = categories.firstWhere(
                        (c) => c.name.contains(v.label),
                        orElse: () => categories.first,
                      );
                    }
                  },
                  decoration: const InputDecoration(labelText: "主类别"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "饰品名称（如：AK47-红线）"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "描述"),
                ),

                const SizedBox(height: 12),

                if (pickedImage != null)
                  Image.file(pickedImage!, width: 140, height: 140, fit: BoxFit.cover),

                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: Text(pickedImage == null ? "上传商品图片" : "重新选择"),
                  onPressed: () async {
                    final pick = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pick != null) {
                      pickedImage = File(pick.path);
                      setState(() {});
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
              child: const Text("创建"),
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final desc = descCtrl.text.trim();

                if (name.isEmpty) {
                  showInfoDialog(title: "错误", content: "请输入饰品名字");
                  return;
                }

                if (pickedImage != null) {
                  final upload = await imageApiDialog.uploadImage(
                    imageFile: pickedImage!,
                    imageType: "product",
                  );

                  if (upload.success && upload.data != null) {
                    imageId = upload.data!.imageId;
                  }
                }

                await storeApiDialog.publishProduct(
                  name: name,
                  price: 0,
                  description: desc,
                  categoryId: selectedBackendCategory.id,
                );

                Navigator.pop(ctx);
                showInfoDialog(title: "成功", content: "饰品创建成功！");
              },
            )
          ],
        );
      },
    ),
  );
}
