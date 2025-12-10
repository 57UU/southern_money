import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import '../widgets/dialog.dart';

class CsgoCategoryDialog extends StatefulWidget {
  const CsgoCategoryDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => const CsgoCategoryDialog(),
    );
  }

  @override
  State<CsgoCategoryDialog> createState() => _CsgoCategoryDialogState();
}

class _CsgoCategoryDialogState extends State<CsgoCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final storeApi = getIt<ApiStoreService>();
  final imageApi = getIt<ApiImageService>();

  String _name = '';
  String _imageId = '';
  bool _loading = false;
  String _imageUrl = '';

  Future<void> _uploadImage() async {
    try {
      setState(() {
        _loading = true;
      });
      // 这里需要根据实际的图片上传API进行调整
      // 暂时注释，后面会实现正确的图片上传逻辑
      setState(() {
        _imageId = "test_image_id";
        _imageUrl = "https://via.placeholder.com/200";
      });
    } catch (e) {
      print("图片上传失败: $e");
      showInfoDialog(title: "上传失败", content: "图片上传失败，请重试");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _createCategory() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _loading = true;
      });

      final response = await storeApi.createCategory(
        category: _name,
        cover: _imageId,
      );

      if (response.success) {
        Navigator.pop(context, true);
        showInfoDialog(title: "成功", content: "分类创建成功");
      } else {
        showInfoDialog(title: "创建失败", content: response.message ?? "创建失败，请重试");
      }
    } catch (e) {
      print("创建分类失败: $e");
      showInfoDialog(title: "创建失败", content: "网络错误，请重试");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '创建CSGO分类',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '分类名称',
                  hintText: '请输入分类名称（如：步枪、手枪、刀具、手套）',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入分类名称';
                  }
                  return null;
                },
                onChanged: (value) {
                  _name = value;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '分类图片（可选）',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _loading ? null : _uploadImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                        color: Colors.grey.withOpacity(0.05),
                      ),
                      child: _imageUrl.isNotEmpty
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  _imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _loading ? '上传中...' : '点击上传分类图片',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _createCategory,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text(
                  '创建',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
