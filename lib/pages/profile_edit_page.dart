import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:southern_money/pages/theme_color_page.dart';
import 'dart:io';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/webapi/index.dart';
import 'package:southern_money/widgets/dialog.dart'
    show DialogState, apiRequestDialog;

class ProfileEditPage extends StatefulWidget {
  final UserProfileResponse userProfileResponse;
  final void Function()? onUpdateSuccess;
  const ProfileEditPage({
    super.key,
    required this.userProfileResponse,
    this.onUpdateSuccess,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final userService = getIt<ApiUserService>();
  final imageService = getIt<ApiImageService>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _avatarPath;
  bool _isAvatarChanged = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userProfileResponse.name;
    emailController.text = widget.userProfileResponse.email;
    _avatarPath = widget.userProfileResponse.avatar;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarPath = pickedFile.path;
        _isAvatarChanged = true;
      });
    }
  }

  Future<void> _uploadAvatar() async {
    if (_avatarPath == null ||
        _avatarPath == widget.userProfileResponse.avatar) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await apiRequestDialog(
        userService.uploadAvatar(_avatarPath!),
        onSuccess: widget.onUpdateSuccess,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('头像上传失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateUserInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 更新用户信息
      await apiRequestDialog(
        userService.updateUser(
          name: nameController.text,
          email: emailController.text,
        ),
        onSuccess: widget.onUpdateSuccess,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('信息更新成功')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('更新失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('编辑个人信息')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              titleText("Avatar Edit"),
              // 头像编辑
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _avatarPath != null
                                ? (_isAvatarChanged
                                      ? FileImage(File(_avatarPath!))
                                            as ImageProvider
                                      : CachedNetworkImageProvider(
                                          imageService.getImageUrl(
                                            _avatarPath!,
                                          ),
                                        ))
                                : null,
                            child: _avatarPath == null
                                ? const Icon(Icons.person, size: 60)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _uploadAvatar,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload),
                      label: const Text('上传头像'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              titleText("Personal Information"),

              // 姓名输入框
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '姓名',
                  hintText: '请输入您的姓名',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入姓名';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 邮箱输入框
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: '邮箱',
                  hintText: '请输入您的邮箱',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入邮箱';
                  }
                  // 简单的邮箱格式验证
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return '请输入有效的邮箱地址';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // 更新信息按钮
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateUserInfo,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('更新个人信息', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
