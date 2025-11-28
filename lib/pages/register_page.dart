import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiLoginService apiLoginService = getIt<ApiLoginService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Placeholder(),
    );
  }
}
