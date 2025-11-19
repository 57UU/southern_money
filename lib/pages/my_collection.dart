import 'package:flutter/material.dart';
import 'package:southern_money/data/local_store.dart';

class MyCollection extends StatefulWidget {
  const MyCollection({super.key});

  @override
  State<MyCollection> createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  final LocalStore _store = LocalStore.instance;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _store.ensureInitialized();
  }

  void _addMockCollection() {
    _counter++;
    _store.addCollection(
      CollectionItem(
        id: 'collection_$_counter',
        title: '收藏的帖子 $_counter',
        note: '这是一个示例收藏，方便测试本地缓存。',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收藏')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMockCollection,
        icon: const Icon(Icons.favorite),
        label: const Text('添加收藏'),
      ),
      body: ValueListenableBuilder<List<CollectionItem>>(
        valueListenable: _store.collections,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('暂未收藏任何内容。'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(
                  '${item.note}\n收藏于: ${item.createdAt.toLocal()}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _store.removeCollection(item.id),
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
