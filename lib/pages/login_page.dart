import 'package:flutter/material.dart';
import 'package:southern_money/pages/register_page.dart';
import 'package:southern_money/pages/set_api_page.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_login.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:southern_money/widgets/router_utils.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer.withOpacity(0.3),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo 图标
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 24),
          // 应用名称
          Text(
            '南方财富',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          // 副标题
          Text(
            '理财有道，一夜暴富',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  final appConfigService = getIt<AppConfigService>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final loginService = getIt<ApiLoginService>();
  final passwordService = getIt<PasswordService>();
  @override
  void initState() {
    super.initState();
    _usernameController.text = passwordService.nicknameValue ?? "";
    _passwordController.text = passwordService.passwordValue ?? "";
  }

  Future<void> _login() async {
    // 验证表单
    if (_formKey.currentState!.validate()) {
      // 表单验证通过，执行登录逻辑
      try {
        ApiResponse<LoginByPasswordResponse>? apiResponse;
        await showLoadingDialog(
          func: () async => {
            apiResponse = await loginService.loginRaw(
              _usernameController.text,
              _passwordController.text,
            ),
          },
        );
        if (apiResponse == null) {
          throw Exception("登录请求失败");
        } else if (!apiResponse!.success) {
          throw Exception(apiResponse?.message ?? "登录失败");
        }
        if (apiResponse!.success) {
          appConfigService.tokenService.updateTokens(
            apiResponse!.data!.token,
            apiResponse!.data!.refreshToken,
          );
          passwordService.updatePassword(
            _usernameController.text,
            _passwordController.text,
          );
        }
      } catch (e) {
        showInfoDialog(title: "登录失败", content: "登录失败: $e");
      }
    }
  }

  void _register() {
    // 注册逻辑
    popupOrNavigate(context, RegisterPage());
  }

  void _guestMode() {
    // 游客模式逻辑
    appConfigService.tokenService.sessionToken.value = "";
  }

  @override
  Widget build(BuildContext context) {
    // 登录表单部分
    final loginForm = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 上半部分：登录表单
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Login标题
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // 用户名输入框
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入用户名';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // 密码输入框
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    border: const UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // 登录按钮
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('登录', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),

                // 注册按钮
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _register,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('注册', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),

            // 下半部分：游客模式按钮
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: _guestMode,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('游客模式', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );

    final loginFormWithScroll = SingleChildScrollView(child: loginForm);
    final loginFormWithApi = Column(
      children: [
        Expanded(child: loginFormWithScroll),
        TextButton(
          onPressed: () {
            popupOrNavigate(context, SetApiUrlPage());
          },
          child: Text("API: ${appConfigService.baseUrl}"),
        ),
      ],
    );
    // 使用LayoutBuilder根据屏幕方向调整布局
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          // 判断是否为横屏
          final isLandscape = orientation == Orientation.landscape;

          if (isLandscape) {
            // 横屏模式：左右分栏
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧填充内容，
                Expanded(flex: 6, child: BrandHeader()),
                // 右侧登录表单，
                Expanded(flex: 4, child: loginFormWithApi),
              ],
            );
          } else {
            // 竖屏模式：保持原有的单列布局
            return loginFormWithApi;
          }
        },
      ),
    );
  }
}
