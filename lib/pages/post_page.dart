import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/webapi/index.dart';
import 'package:southern_money/widgets/dialog.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //service
  var imageService = getIt<ApiImageService>();
  var postService = getIt<ApiPostService>();

  // 添加标签
  void _addTag() {
    if (_tagController.text.isNotEmpty && _tags.length < 5) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  // 移除标签
  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  // 选择图片
  Future<void> _pickImage() async {
    if (_images.length >= 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('最多只能选择3张图片')));
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile);
      });
    }
  }

  // 移除图片
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // 验证表单并发布
  void _publish() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('请输入标题'),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
      return;
    }

    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('请输入内容'),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
      return;
    }
    Future<ApiResponse> post() async {
      // 上传图片
      List<String> imageIds = [];
      for (var image in _images) {
        ApiResponse response;
        if (kIsWeb) {
          // Web平台上传
          response = await imageService.uploadImageWeb(imagePath: image.path);
        } else {
          // 移动平台上传
          response = await imageService.uploadImage(
            imageFile: File(image.path),
          );
        }

        if (response.success && response.data != null) {
          imageIds.add(response.data.imageId);
        } else {
          return ApiResponse.fail(message: "图片上传失败: ${response.message}");
        }
      }

      // 上传帖子
      return postService.createPost(
        title: _titleController.text,
        content: _contentController.text,
        tags: _tags,
        imageIds: imageIds,
      );
    }

    final success = await apiRequestDialog(post());
    if (success == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('发布新内容'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          FilledButton(
            onPressed: _publish,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              textStyle: const TextStyle(fontWeight: FontWeight.w500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('发布'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题输入
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '请输入标题',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                maxLength: 100,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // 标签部分
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '标签',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagController,
                          decoration: InputDecoration(
                            hintText: _tags.length >= 5 ? '最多添加5个标签' : '添加标签',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.outline,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceVariant,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          enabled: _tags.length < 5,
                          onSubmitted: (value) => _addTag(),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _addTag,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('添加'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 14),
                          minimumSize: const Size(80, 48),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 显示已添加的标签
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tags.asMap().entries.map((entry) {
                      int index = entry.key;
                      String tag = entry.value;
                      return Chip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                        onDeleted: () => _removeTag(index),
                        backgroundColor: colorScheme.secondaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 内容输入
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '分享你的想法...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
                maxLines: null,
                minLines: 10,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
                textInputAction: TextInputAction.done,
              ),

              // 图片选择和预览
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '添加图片（最多3张）',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // 图片预览列表
                      ..._images.asMap().entries.map((entry) {
                        int index = entry.key;
                        XFile image = entry.value;
                        return Stack(
                          children: [
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: kIsWeb
                                    ? Image.network(
                                        image.path,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(image.path),
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: colorScheme.error,
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(28, 28),
                                  elevation: 2,
                                ),
                                onPressed: () => _removeImage(index),
                                tooltip: '删除图片',
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      // 添加图片按钮
                      if (_images.length < 3)
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: colorScheme.outlineVariant),
                          ),
                          child: InkWell(
                            onTap: _pickImage,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colorScheme.surfaceVariant.withOpacity(
                                  0.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 32,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  Text(
                                    '添加图片',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 12,
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
              // 底部间距
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }
}
