import 'package:flutter/material.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class AdminPostBlockHistory extends StatelessWidget {
  final PostPageItemResponse response;
  const AdminPostBlockHistory({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('封禁历史记录')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 帖子基本信息
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '帖子ID: ${response.id}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '当前状态: ${response.isBlocked ? '已封禁' : '正常'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: response.isBlocked ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 封禁历史记录列表
            const Text(
              '历史操作记录',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: response.postBlocks.isEmpty
                  ? const Center(child: Text('没有历史操作记录'))
                  : ListView.builder(
                      itemCount: response.postBlocks.length,
                      itemBuilder: (context, index) {
                        final blockHistory = response.postBlocks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      blockHistory.isBlock ? '封禁操作' : '解封操作',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: blockHistory.isBlock
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    Text(
                                      '${blockHistory.actionTime.year}-${blockHistory.actionTime.month.toString().padLeft(2, '0')}-${blockHistory.actionTime.day.toString().padLeft(2, '0')} ${blockHistory.actionTime.hour.toString().padLeft(2, '0')}:${blockHistory.actionTime.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${blockHistory.isBlock ? '封禁' : '解封'}原因: ${blockHistory.reason}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '操作人: ${blockHistory.operator.name}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
