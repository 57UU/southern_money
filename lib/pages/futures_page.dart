import 'package:flutter/material.dart';

class FuturesPage extends StatelessWidget {
  const FuturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('期货'),
        elevation: 0,
      ),
      body: const Center(
        child: Text('期货页面'),
      ),
    );
  }
}