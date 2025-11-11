import 'package:flutter/material.dart';

class GoldPage extends StatelessWidget {
  const GoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('黄金'),
        elevation: 0,
      ),
      body: const Center(
        child: Text('黄金页面'),
      ),
    );
  }
}