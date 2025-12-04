import 'dart:math';

import 'package:flutter/material.dart';
import 'package:southern_money/data/local_store.dart';

class MyTransaction extends StatefulWidget {
  const MyTransaction({super.key});

  @override
  State<MyTransaction> createState() => _MyTransactionState();
}

class _MyTransactionState extends State<MyTransaction> {
  final LocalStore _store = LocalStore.instance;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _store.ensureInitialized();
  }

  void _addMockTransaction() {
    final actions = ['买入', '卖出', '转账'];
    final action = actions[_random.nextInt(actions.length)];
    final amount = (_random.nextDouble() * 5000) + 100;
    _store.addTransaction(
      TransactionRecord(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        action: action,
        amount: double.parse(amount.toStringAsFixed(2)),
        CreateTime: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('交易记录')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMockTransaction,
        icon: const Icon(Icons.receipt_long),
        label: const Text('模拟交易'),
      ),
      body: ValueListenableBuilder<List<TransactionRecord>>(
        valueListenable: _store.transactions,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('暂无交易记录。'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final txn = items[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(txn.action.substring(0, 1)),
                  ),
                  title: Text(
                    '${txn.action} · ¥${txn.amount.toStringAsFixed(2)}',
                  ),
                  subtitle: Text('时间：${txn.CreateTime.toLocal()}'),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}
