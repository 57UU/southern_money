import 'dart:math';

import 'package:flutter/material.dart';
import 'package:southern_money/setting/app_config.dart';

// 波浪绘制器类
class WavePainter extends CustomPainter {
  final Color color;
  final double waveHeight;
  final double waveLength;
  final double offset;

  WavePainter({
    required this.color,
    required this.waveHeight,
    required this.waveLength,
    this.offset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.moveTo(0, size.height);

    // 绘制波浪曲线
    for (double i = 0; i <= size.width; i++) {
      final y = waveHeight * sin((i / waveLength) + offset) + size.height / 2;
      if (i == 0) {
        path.moveTo(i, y);
      } else {
        path.lineTo(i, y);
      }
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PaddingContainer extends StatelessWidget {
  const PaddingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 添加一些装饰性的波浪线条和形状
            Container(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  // 第一个波浪
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(200, 100),
                      painter: WavePainter(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        waveHeight: 15,
                        waveLength: 40,
                      ),
                    ),
                  ),
                  // 第二个波浪
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(200, 100),
                      painter: WavePainter(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.2),
                        waveHeight: 10,
                        waveLength: 30,
                        offset: 10,
                      ),
                    ),
                  ),
                  // 装饰性边框
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '南方财富',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              '智能理财，财富增长',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // 验证表单
    if (_formKey.currentState!.validate()) {
      // 表单验证通过，执行登录逻辑
      //TODO: 登录逻辑
      sessionToken.value = "1919810";
    }
  }

  void _register() {
    // 注册逻辑
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('注册功能待实现')));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sessionToken,
      builder: (context, _) {
        // 登录表单部分
        final loginForm = Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
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
              ],
            ),
          ),
        );

        final loginFormWithScroll = SingleChildScrollView(child: loginForm);
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
                    Expanded(flex: 6, child: PaddingContainer()),
                    // 右侧登录表单，
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(child: loginFormWithScroll),
                    ),
                  ],
                );
              } else {
                // 竖屏模式：保持原有的单列布局
                return loginFormWithScroll;
              }
            },
          ),
        );
      },
    );
  }
}
