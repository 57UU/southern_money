import 'package:flutter/material.dart';
import 'package:southern_money/pages/theme_color_page.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_login.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiLoginService apiLoginService = getIt<ApiLoginService>();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          titleText("Nickname"),
          TextField(
            controller: nicknameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              hintText: "请输入昵称",
            ),
          ),

          titleText("Password"),
          TextField(
            controller: passwordController,
            obscureText: !showPassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              hintText: "请输入密码",
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: BackButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: content,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _register,
        label: const Icon(Icons.arrow_forward),
        icon: const Text("立即注册"),
      ),
    );
  }

  Future<void> _register() async {
    final nickname = nicknameController.text.trim();
    final password = passwordController.text.trim();

    if (nickname.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("请输入昵称和密码")));
      return;
    }

    late ApiResponse apiResponse;

    await showLoadingDialog(
      func: () async {
        apiResponse = await apiLoginService.register(nickname, password);
      },
    );

    if (!mounted) return;

    if (apiResponse.success) {
      Navigator.of(context, rootNavigator: true).pop();

      showInfoDialog(title: "注册成功", content: "您可以使用 $nickname 登录");
    } else {
      showInfoDialog(title: "注册失败", content: apiResponse.message ?? "注册失败");
    }
  }
}
