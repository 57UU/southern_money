import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southern_money/setting/ensure_initialized.dart';

const String _selectionsKey = 'local_store_selections';
const String _collectionsKey = 'local_store_collections';
const String _transactionsKey = 'local_store_transactions';

final preferences = getIt<SharedPreferences>();

class SelectionItem {
  final String id;
  final String name;
  final String code;
  final double price;
  final DateTime updatedAt;

  const SelectionItem({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'price': price,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SelectionItem.fromMap(Map<String, dynamic> map) {
    return SelectionItem(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      price: (map['price'] as num).toDouble(),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}

class CollectionItem {
  final String id;
  final String title;
  final String note;
  final DateTime CreateTime;

  const CollectionItem({
    required this.id,
    required this.title,
    required this.note,
    required this.CreateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'CreateTime': CreateTime.toIso8601String(),
    };
  }

  factory CollectionItem.fromMap(Map<String, dynamic> map) {
    return CollectionItem(
      id: map['id'] as String,
      title: map['title'] as String,
      note: map['note'] as String,
      CreateTime: DateTime.parse(map['CreateTime'] as String),
    );
  }
}

class TransactionRecord {
  final String id;
  final String action;
  final double amount;
  final DateTime CreateTime;

  const TransactionRecord({
    required this.id,
    required this.action,
    required this.amount,
    required this.CreateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'amount': amount,
      'CreateTime': CreateTime.toIso8601String(),
    };
  }

  factory TransactionRecord.fromMap(Map<String, dynamic> map) {
    return TransactionRecord(
      id: map['id'] as String,
      action: map['action'] as String,
      amount: (map['amount'] as num).toDouble(),
      CreateTime: DateTime.parse(map['CreateTime'] as String),
    );
  }
}

class LocalStore {
  LocalStore._();

  static final LocalStore instance = LocalStore._();

  bool _initialized = false;

  final ValueNotifier<List<SelectionItem>> selections =
      ValueNotifier<List<SelectionItem>>(<SelectionItem>[]);
  final ValueNotifier<List<CollectionItem>> collections =
      ValueNotifier<List<CollectionItem>>(<CollectionItem>[]);
  final ValueNotifier<List<TransactionRecord>> transactions =
      ValueNotifier<List<TransactionRecord>>(<TransactionRecord>[]);

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;
    selections.value = _loadList(
      _selectionsKey,
      (map) => SelectionItem.fromMap(map),
    );
    collections.value = _loadList(
      _collectionsKey,
      (map) => CollectionItem.fromMap(map),
    );
    transactions.value = _loadList(
      _transactionsKey,
      (map) => TransactionRecord.fromMap(map),
    );
  }

  List<T> _loadList<T>(String key, T Function(Map<String, dynamic>) converter) {
    final raw = preferences.getString(key);
    if (raw == null || raw.isEmpty) {
      return <T>[];
    }
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => converter(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _saveList<T>(String key, List<T> list, Map Function(T) mapper) {
    final encoded = jsonEncode(list.map(mapper).toList());
    return preferences.setString(key, encoded);
  }

  Future<void> upsertSelection(SelectionItem item) async {
    await ensureInitialized();
    final current = [...selections.value];
    final index = current.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      current[index] = item;
    } else {
      current.insert(0, item);
    }
    selections.value = current;
    await _saveList(_selectionsKey, current, (value) => value.toMap());
  }

  Future<void> removeSelection(String id) async {
    await ensureInitialized();
    final current = selections.value.where((item) => item.id != id).toList();
    selections.value = current;
    await _saveList(_selectionsKey, current, (value) => value.toMap());
  }

  Future<void> addCollection(CollectionItem item) async {
    await ensureInitialized();
    final current = [...collections.value];
    current.insert(0, item);
    collections.value = current;
    await _saveList(_collectionsKey, current, (value) => value.toMap());
  }

  Future<void> removeCollection(String id) async {
    await ensureInitialized();
    final current = collections.value.where((item) => item.id != id).toList();
    collections.value = current;
    await _saveList(_collectionsKey, current, (value) => value.toMap());
  }

  Future<void> addTransaction(TransactionRecord record) async {
    await ensureInitialized();
    final current = [...transactions.value];
    current.insert(0, record);
    transactions.value = current;
    await _saveList(_transactionsKey, current, (value) => value.toMap());
  }

  Future<void> clearAll() async {
    await ensureInitialized();
    selections.value = <SelectionItem>[];
    collections.value = <CollectionItem>[];
    transactions.value = <TransactionRecord>[];
    await preferences.remove(_selectionsKey);
    await preferences.remove(_collectionsKey);
    await preferences.remove(_transactionsKey);
  }
}
