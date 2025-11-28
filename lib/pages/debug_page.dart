import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/setting/ensure_initialized.dart';

import 'login_page.dart';

class DebugPage extends StatelessWidget {
  DebugPage({super.key});

  final appConfigService = getIt<AppConfigService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            Text("session key: ${appConfigService.sessionTokenValue??"undefined"}"),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('登录'),
            ),
          ],
        ),
      ),
    );
  }
}
