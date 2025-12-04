import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_user.dart';
import 'package:southern_money/widgets/common_widget.dart';
import 'package:southern_money/widgets/dialog.dart';

class OpenAnAccount extends StatefulWidget {
  const OpenAnAccount({super.key});

  @override
  State<OpenAnAccount> createState() => _OpenAnAccountState();
}

class _OpenAnAccountState extends State<OpenAnAccount> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('开户'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '开户协议',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionTitle('1. 服务条款'),
                      _buildSectionContent('欢迎使用南方资金开户服务。在使用本服务前，请仔细阅读以下条款。'),
                      _buildSectionTitle('2. 风险提示'),
                      _buildSectionContent(
                        '投资有风险，入市需谨慎。您应充分了解投资可能存在的风险，并根据自身的风险承受能力做出投资决策。',
                      ),
                      _buildSectionTitle('3. 账户安全'),
                      _buildSectionContent(
                        '请妥善保管您的账户信息和密码，不要将账户信息泄露给他人。如发现账户异常，请及时联系我们。',
                      ),
                      _buildSectionTitle('4. 隐私保护'),
                      _buildSectionContent(
                        '我们重视您的隐私保护，将按照相关法律法规的要求，保护您的个人信息安全。',
                      ),
                      _buildSectionTitle('5. 法律责任'),
                      _buildSectionContent('您应遵守国家法律法规，不得利用本服务从事任何违法违规活动。'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _agreedToTerms = value ?? false;
                    });
                  },
                ),
                const Text('我已阅读并同意以上开户协议'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _agreedToTerms
                    ? () {
                        _showConfirmationDialog();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('确认开户', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(content, style: TextStyle(fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() async {
    var result = await openAnAccountDialog();
    if (result == true) {
      //user agreed to open an account
      if (context.mounted) {
        Navigator.of(logicRootContext).pop();
      }
    }
  }
}

enum DialogState { conform, loading, success, error }

//the return value is true if the user agreed to open an account
Future<bool?> openAnAccountDialog() {
  DialogState dialogState = DialogState.conform;
  ContextWrapper contextWrapper = ContextWrapper();
  rebuildDialog() {
    if (contextWrapper.context.mounted) {
      (contextWrapper.context as Element).markNeedsBuild();
    }
  }

  final userService = getIt<ApiUserService>();

  String errorMessage = "";
  String successMessage = "开户成功";
  late CancelableOperation myCancelableFuture;
  Future<dynamic> future() async {
    await userService.openAccount();

    // 检查操作是否已被取消，如果已取消则不再更新状态
    if (!myCancelableFuture.isCanceled) {
      //change state
      dialogState = DialogState.success;
      rebuildDialog();
    }
  }

  return showDialog(
    barrierDismissible: false,
    context: logicRootContext,
    useRootNavigator: false,
    builder: (context) {
      contextWrapper.context = context;
      return AlertDialog(
        title: Text(switch (dialogState) {
          DialogState.conform => '确认开户？',
          DialogState.loading => '开户中',
          DialogState.success => '开户成功',
          DialogState.error => '开户失败',
        }),
        content: AnimatedSize(
          duration: Duration(milliseconds: appConfigService.animationTime),
          curve: Curves.easeOutQuart,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                switch (dialogState) {
                  DialogState.conform => const Text('请确认同意服务协议，并开户'),
                  DialogState.loading => const CircularProgressIndicator(),
                  DialogState.success => Text(successMessage),
                  DialogState.error => Text(errorMessage),
                },
              ],
            ),
          ),
        ),
        actions: switch (dialogState) {
          DialogState.conform => [
            TextButton(
              onPressed: () {
                //forward to next state
                dialogState = DialogState.loading;
                myCancelableFuture = CancelableOperation.fromFuture(future());
                rebuildDialog();
              },
              child: const Text('确认开户'),
            ),
            TextButton(
              onPressed: () {
                //pop the dialog
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
          ],
          DialogState.loading => [
            TextButton(
              onPressed: () {
                //cancel the loading
                myCancelableFuture.cancel();

                errorMessage = "用户取消开户";
                dialogState = DialogState.error;
                rebuildDialog();
              },
              child: const Text('取消'),
            ),
          ],
          DialogState.success => [
            TextButton(
              onPressed: () {
                //pop the dialog
                Navigator.of(context).pop(true);
              },
              child: Text("OK"),
            ),
          ],
          DialogState.error => [
            TextButton(
              onPressed: () {
                //pop the dialog
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        },
      );
    },
  );
}
