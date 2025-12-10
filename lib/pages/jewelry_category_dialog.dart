import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/dialog.dart';

/// 这里只在对话框内部用，不和筛选器的枚举互相传递，所以单独定义一个即可
enum _MainCategory {
  rifle("步枪"),
  pistol("手枪"),
  knife("刀具"),
  glove("手套");

  final String label;
  const _MainCategory(this.label);
}

class JewelryCategoryDialog extends StatefulWidget {
  const JewelryCategoryDialog({super.key});

  /// 静态方法，外部调用：`final ok = await JewelryCategoryDialog.show(context);`
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const JewelryCategoryDialog(),
    );
  }

  @override
  State<JewelryCategoryDialog> createState() => _JewelryCategoryDialogState();
}

class _JewelryCategoryDialogState extends State<JewelryCategoryDialog> {
  final storeApi = getIt<ApiStoreService>();
  final imageApi = getIt<ApiImageService>();

  final TextEditingController _nameController = TextEditingController();

  _MainCategory _selectedMain = _MainCategory.rifle;

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
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
    if (name.isEmpty) {
      showInfoDialog(title: "错误", content: "请输入分类名字，比如 “AK-47 | 红线”");
      return;
    }

    if (_submitting) return;
    setState(() => _submitting = true);

    String coverImageId = "";

    // 1. 先上传封面图（如果选了）
    if (_pickedImage != null) {
      final path = _pickedImage!.path;
      ApiResponse<ImageUploadResponse> res;

      if (kIsWeb) {
        // 如果你的 ApiImageService 有专门的 web 方法，就这样写；
        // 否则可以自己在 ApiImageService 里仿照 PostPage 实现一个 uploadImageWeb。
        res = await imageApi.uploadImageWeb(
          imagePath: path,
          imageType: "category",
        );
      } else {
        res = await imageApi.uploadImage(
          imageFile: File(path),
          imageType: "category",
        );
      }

      if (!res.success || res.data == null) {
        setState(() => _submitting = false);
        showInfoDialog(title: "错误", content: "封面上传失败：${res.message}");
        return;
      }

      coverImageId = res.data!.imageId;
    }

    // 2. 组合真正的分类名称：例如 “步枪 - AK-47 | 红线”
    final fullCategoryName = "${_selectedMain.label} - $name";

    // 3. 调用后端创建分类
    await showLoadingDialog(
      title: "正在创建分类",
      func: () async {
        await storeApi.createCategory(
          category: fullCategoryName,
          cover: coverImageId,
        );
      },
    );

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text("创建饰品分类"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 选择大类
            Row(
              children: [
                const Text("主类别："),
                const SizedBox(width: 8),
                DropdownButton<_MainCategory>(
                  value: _selectedMain,
                  items: _MainCategory.values
                      .map(
                        (m) => DropdownMenuItem(
                          value: m,
                          child: Text(m.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _selectedMain = v);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 输入具体名称
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "具体名称（例如：AK-47 | 红线）",
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 16),

            // 预览图片
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
              label: Text(_pickedImage == null ? "选择封面图片" : "重新选择封面"),
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
          child: const Text("创建"),
        ),
      ],
    );
  }
}
