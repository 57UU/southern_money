import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_admin.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/common_widget.dart';

class AdminStatistics extends StatefulWidget {
  const AdminStatistics({super.key});

  @override
  State<AdminStatistics> createState() => _AdminStatisticsState();
}

class _AdminStatisticsState extends State<AdminStatistics>
    with AutomaticKeepAliveClientMixin {
  final adminService = getIt<ApiAdminService>();

  // 状态管理
  AdminStatisticsResponse? _statistics;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  // 获取统计数据
  Future<void> _fetchStatistics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await adminService.getStatistics();

    setState(() {
      _isLoading = false;
      if (response.success && response.data != null) {
        _statistics = response.data!;
      } else {
        _errorMessage = response.message ?? '获取统计数据失败';
      }
    });
  }

  // 刷新数据
  Future<void> _refreshData() async {
    await _fetchStatistics();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('数据已刷新')));
  }

  // 创建统计卡片
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 300,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面标题和刷新按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText('系统统计'),
                IconButton(
                  onPressed: _refreshData,
                  icon: const Icon(Icons.refresh),
                  tooltip: '刷新数据',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 加载状态
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            // 错误状态
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '获取数据失败',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchStatistics,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                ),
              )
            // 数据展示
            else if (_statistics != null)
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 统计卡片流式布局
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildStatCard(
                            title: '总用户数',
                            value: _statistics!.totalUsers.toString(),
                            icon: Icons.people,
                            color: Colors.blue,
                          ),
                          _buildStatCard(
                            title: '总产品数',
                            value: _statistics!.totalProducts.toString(),
                            icon: Icons.inventory_2,
                            color: Colors.green,
                          ),
                          _buildStatCard(
                            title: '总交易数',
                            value: _statistics!.totalTransactions.toString(),
                            icon: Icons.receipt_long,
                            color: Colors.purple,
                          ),
                          _buildStatCard(
                            title: '最近交易数',
                            value: _statistics!.recentTransactions.toString(),
                            icon: Icons.trending_up,
                            color: Colors.orange,
                          ),
                          _buildStatCard(
                            title: '被封禁用户',
                            value: _statistics!.bannedUsers.toString(),
                            icon: Icons.block,
                            color: Colors.red,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 统计摘要
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '统计摘要',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildSummaryItem(
                                '正常用户比例',
                                '${((_statistics!.totalUsers - _statistics!.bannedUsers) / _statistics!.totalUsers * 100).toStringAsFixed(1)}%',
                                Icons.person,
                                Colors.green,
                              ),
                              const SizedBox(height: 8),
                              _buildSummaryItem(
                                '封禁用户比例',
                                '${(_statistics!.bannedUsers / _statistics!.totalUsers * 100).toStringAsFixed(1)}%',
                                Icons.person_off,
                                Colors.red,
                              ),
                              const SizedBox(height: 8),
                              _buildSummaryItem(
                                '平均每用户交易数',
                                _statistics!.totalUsers > 0
                                    ? (_statistics!.totalTransactions /
                                              _statistics!.totalUsers)
                                          .toStringAsFixed(2)
                                    : '0',
                                Icons.calculate,
                                Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 构建摘要项
  Widget _buildSummaryItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
