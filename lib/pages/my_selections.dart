import 'dart:math';

import 'package:flutter/material.dart';
import 'package:southern_money/data/local_store.dart';

class MySelections extends StatefulWidget {
  const MySelections({super.key});

  @override
  State<MySelections> createState() => _MySelectionsState();
}

class _MySelectionsState extends State<MySelections> {
  final LocalStore _store = LocalStore.instance;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _store.ensureInitialized();
  }

  void _addMockSelection() {
    final symbols = <Map<String, String>>[
      {'name': '黄金', 'code': 'XAU/USD'},
      {'name': '原油宝', 'code': 'OIL/USD'},
      {'name': '比特币', 'code': 'BTC/USD'},
      {'name': '龙狙', 'code': 'AWP-DL'},
    ];
    final target = symbols[_random.nextInt(symbols.length)];
    final price = 1000 + _random.nextDouble() * 800;
    _store.upsertSelection(
      SelectionItem(
        id: target['code']!,
        name: target['name']!,
        code: target['code']!,
        price: double.parse(price.toStringAsFixed(2)),
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('自选')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMockSelection,
        icon: const Icon(Icons.add),
        label: const Text('添加示例'),
      ),
      body: ValueListenableBuilder<List<SelectionItem>>(
        valueListenable: _store.selections,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('暂无自选，点击右下角添加示例。'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _store.removeSelection(item.id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.code} · 更新于 ${item.updatedAt.toLocal()}'),
                  trailing: Text('¥${item.price.toStringAsFixed(2)}'),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}
