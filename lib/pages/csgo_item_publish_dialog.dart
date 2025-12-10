import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import '../widgets/dialog.dart';

class CsgoItemPublishDialog extends StatefulWidget {
  final List<CategoryResponse> categories;

  const CsgoItemPublishDialog({super.key, required this.categories});

  static Future<bool?> show(BuildContext context, List<CategoryResponse> categories) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CsgoItemPublishDialog(categories: categories),
    );
  }

  @override
  State<CsgoItemPublishDialog> createState() => _CsgoItemPublishDialogState();
}

class _CsgoItemPublishDialogState extends State<CsgoItemPublishDialog> {
  final _formKey = GlobalKey<FormState>();
  final storeApi = getIt<ApiStoreService>();
  final imageApi = getIt<ApiImageService>();

  String _name = '';
  CategoryResponse? _selectedCategory;
  double _price = 0.0;
  String _imageId = '';

  bool _loading = false;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    }
  }

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

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      showInfoDialog(title: "错误", content: "请选择分类");
      return;
    }

    try {
      setState(() {
        _loading = true;
      });

      final response = await storeApi.publishProduct(
        name: _name,
        price: _price,
        description: "", // 暂时使用空字符串，后面可以添加描述字段
        categoryId: _selectedCategory!.id,
      );

      if (response.success) {
        Navigator.pop(context, true);
        showInfoDialog(title: "成功", content: "商品发布成功");
      } else {
        showInfoDialog(title: "发布失败", content: response.message ?? "发布失败，请重试");
      }
    } catch (e) {
      print("发布商品失败: $e");
      showInfoDialog(title: "发布失败", content: "网络错误，请重试");
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
        '发布CSGO饰品',
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
                  labelText: '商品名称',
                  hintText: '请输入CSGO饰品名称',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入商品名称';
                  }
                  return null;
                },
                onChanged: (value) {
                  _name = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CategoryResponse>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: '分类',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                ),
                items: widget.categories.map((category) {
                  return DropdownMenuItem<CategoryResponse>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '请选择分类';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '价格',
                  hintText: '请输入商品价格',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  prefixText: '￥',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入价格';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price < 0) {
                    return '请输入有效的价格';
                  }
                  return null;
                },
                onChanged: (value) {
                  _price = double.tryParse(value) ?? 0.0;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '商品图片',
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
                      height: 200,
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
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _loading ? '上传中...' : '点击上传图片',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
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
          onPressed: _loading ? null : _publish,
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
                  '发布',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
