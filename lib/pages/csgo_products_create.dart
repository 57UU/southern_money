import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:decimal/decimal.dart';

class CsgoProductsCreate extends StatefulWidget {
  final String categoryId;
  const CsgoProductsCreate({super.key, required this.categoryId});

  @override
  State<CsgoProductsCreate> createState() => _CsgoProductsCreateState();
}

class _CsgoProductsCreateState extends State<CsgoProductsCreate> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final storeApi = getIt<ApiStoreService>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 创建产品
  Future _createProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      Future<ApiResponse<dynamic>> _callApi() async {
        // 解析价格
        final price = Decimal.tryParse(_priceController.text.trim());
        if (price == null) {
          throw Exception('价格格式不正确');
        }

        // 创建产品
        final response = await storeApi.publishProduct(
          name: _nameController.text.trim(),
          price: price,
          description: _descriptionController.text.trim(),
          categoryId: widget.categoryId,
        );

        return response;
      }

      final result = await apiRequestDialog(
        _callApi(),
        confirmMessage: '确定要发布这个产品吗？',
      );

      // 确保提交状态被重置
      if (_isSubmitting) {
        setState(() {
          _isSubmitting = false;
        });
      }

      if (result == true) {
        popDialog(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布产品'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSubmitting ? null : _createProduct,
        icon: _isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: colorScheme.onPrimary),
              )
            : const Icon(Icons.send),
        label: Text('发布产品'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 产品名称输入框
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '产品名称',
                  hintText: '请输入产品名称',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入产品名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 产品价格输入框
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '产品价格',
                  hintText: '请输入产品价格',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入产品价格';
                  }
                  if (Decimal.tryParse(value.trim()) == null) {
                    return '请输入有效的价格数字';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 产品描述输入框
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: '产品描述',
                  hintText: '请输入产品描述',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入产品描述';
                  }
                  return null;
                },
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
                          '请填写完整的产品信息',
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
