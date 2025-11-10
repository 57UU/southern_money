import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/setting/app_config.dart';

import 'login_page.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

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
            Text("session key: ${sessionToken.value}"),
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
