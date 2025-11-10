import 'package:flutter/material.dart';

class MySelections extends StatefulWidget {
  const MySelections({super.key});

  @override
  State<MySelections> createState() => _MySelectionsState();
}

class _MySelectionsState extends State<MySelections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('自选')));
  }
}
