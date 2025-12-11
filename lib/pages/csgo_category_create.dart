import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'dart:io';

class CsgoCategoryCreate extends StatefulWidget {
  const CsgoCategoryCreate({super.key});

  @override
  State<CsgoCategoryCreate> createState() => _CsgoCategoryCreateState();
}

class _CsgoCategoryCreateState extends State<CsgoCategoryCreate> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final storeApi = getIt<ApiStoreService>();
  final imageApi = getIt<ApiImageService>();

  File? _imageFile;
  String? _imagePath; // 用于Web平台存储图片路径
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // 选择图片
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // Web平台使用路径
          _imagePath = pickedFile.path;
          _imageFile = null;
        } else {
          // 移动平台使用File对象
          _imageFile = File(pickedFile.path);
          _imagePath = null;
        }
      });
    }
  }

  // 上传图片
  Future<String?> _uploadImage() async {
    // 检查是否有图片需要上传
    if (kIsWeb && _imagePath == null) return null;
    if (!kIsWeb && _imageFile == null) return null;

    ApiResponse<ImageUploadResponse> response;

    if (kIsWeb) {
      // Web平台使用特殊上传方法
      response = await imageApi.uploadImageWeb(
        imagePath: _imagePath!,
        imageType: "image/jpeg",
        description: "分类封面图片",
      );
    } else {
      // 移动平台使用常规上传方法
      response = await imageApi.uploadImage(
        imageFile: _imageFile!,
        imageType: "image/jpeg",
        description: "分类封面图片",
      );
    }
    return response.data!.imageId;
  }

  // 创建分类
  Future _createCategory() async {
    if (_formKey.currentState!.validate()) {
      // 检查是否有图片
      if ((kIsWeb && _imagePath == null) || (!kIsWeb && _imageFile == null)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('请上传分类封面图片')));
        return ApiResponse.fail();
      }

      setState(() {
        _isUploading = true;
      });

      Future<ApiResponse<dynamic>> _callApi() async {
        // 先上传图片
        final imageUrl = await _uploadImage();

        // 设置上传状态为false
        setState(() {
          _isUploading = false;
        });

        if (imageUrl == null) {
          throw Exception('图片上传失败');
        }

        // 创建分类
        final response = await storeApi.createCategory(
          category: _nameController.text.trim(),
          cover: imageUrl,
        );

        return response;
      }

      final result = await apiRequestDialog(
        _callApi(),
        confirmMessage: '确定要创建这个分类吗？',
      );

      // 确保上传状态被重置
      if (_isUploading) {
        setState(() {
          _isUploading = false;
        });
      }

      if (result == true && mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建分类'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isUploading ? null : _createCategory,
        icon: _isUploading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: colorScheme.onPrimary),
              )
            : const Icon(Icons.send),
        label: Text('创建分类'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分类名称输入框
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '分类名称',
                  hintText: '请输入分类名称',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入分类名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 图片上传区域
              Text(
                '分类封面图片',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _isUploading ? null : _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                    color: colorScheme.surface,
                  ),
                  child: _isUploading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        )
                      : (kIsWeb && _imagePath != null) ||
                            (!kIsWeb && _imageFile != null)
                      ? Stack(
                          children: [
                            Center(
                              child: kIsWeb
                                  ? Image.network(
                                      _imagePath!,
                                      fit: BoxFit.contain,
                                      height: double.infinity,
                                      width: double.infinity,
                                    )
                                  : Image.file(
                                      _imageFile!,
                                      fit: BoxFit.contain,
                                      height: double.infinity,
                                      width: double.infinity,
                                    ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor: colorScheme.shadow.withOpacity(
                                  0.7,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: colorScheme.onSurface,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _imageFile = null;
                                      _imagePath = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '点击上传封面图片',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // 提示信息
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '请上传清晰、美观的封面图片',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
