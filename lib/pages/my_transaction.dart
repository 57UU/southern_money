import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_transaction.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart'
    show ApiResponse, PagedResponse, TransactionRecordResponse;
import 'package:southern_money/widgets/styled_card.dart';

class MyTransaction extends StatefulWidget {
  const MyTransaction({super.key});

  @override
  State<MyTransaction> createState() => _MyTransactionState();
}

class _MyTransactionState extends State<MyTransaction> {
  final transactionService = getIt<ApiTransactionService>();
  List<TransactionRecordResponse> _transactionRecords = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadTransactionRecords();
  }

  Future<void> _loadTransactionRecords({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _currentPage = 1;
        _transactionRecords.clear();
        _hasMore = true;
      }
    });

    try {
      final response = await transactionService.getMyTransactionRecords(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response.success && response.data != null) {
        final pagedData = response.data!;
        final newRecords = pagedData.items;

        setState(() {
          if (_currentPage == 1) {
            _transactionRecords = newRecords;
          } else {
            _transactionRecords.addAll(newRecords);
          }
          _hasMore = newRecords.length == _pageSize;
          _currentPage++;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? '加载交易记录失败')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载交易记录失败: $e')),
        );
      }
    }
  }

  Widget _buildTransactionItem(TransactionRecordResponse record) {
    return StyledCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '交易ID: ${record.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '¥${record.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '产品ID: ${record.productId}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '数量: ${record.quantity}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '单价: ¥${record.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${record.purchaseTime.toString().substring(0, 16)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _loadTransactionRecords(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的交易'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadTransactionRecords(isRefresh: true);
            },
            label: const Text('刷新'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _isLoading && _transactionRecords.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _transactionRecords.isEmpty
              ? const Center(child: Text('暂无交易记录'))
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.pixels ==
                              notification.metrics.maxScrollExtent &&
                          _hasMore &&
                          !_isLoading) {
                        _loadTransactionRecords();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: _transactionRecords.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _transactionRecords.length) {
                          if (_isLoading) {
                            return const Center(child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ));
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: const Text('没有更多交易记录了'),
                            );
                          }
                        }
                        final record = _transactionRecords[index];
                        return _buildTransactionItem(record);
                      },
                    ),
                  ),
                ),
    );
  }
}
