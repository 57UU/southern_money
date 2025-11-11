import 'package:flutter/material.dart';

class CryptoCurrencyPage extends StatelessWidget {
  const CryptoCurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('虚拟货币'),
        elevation: 0,
      ),
      body: const Center(
        child: Text('虚拟货币页面'),
      ),
    );
  }
}