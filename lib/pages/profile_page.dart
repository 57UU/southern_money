import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_collection.dart';
import 'my_message.dart';
import 'my_selections.dart';
import 'my_transaction.dart';
import 'setting.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的'), elevation: 0, actions: [
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户信息卡片
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '鱼幼薇',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: 114514',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('编辑个人资料')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 资产概览
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '资产概览',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAssetItem(
                          '总资产',
                          '¥128,888.88',
                          Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildAssetItem(
                          '今日收益',
                          '+¥1,234.56',
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAssetItem(
                          '累计收益',
                          '+¥12,345.67',
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildAssetItem('收益率', '+10.58%', Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 功能菜单
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Theme.of(context).cardColor)],
              ),
              child: Column(
                children: [
                  _buildMenuItem(context, '我的自选', Icons.star_border, () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const MySelections(),
                      ),
                    );
                  }),
                  _buildMenuItem(context, '交易记录', Icons.history, () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const MyTransaction(),
                      ),
                    );
                  }),
                  _buildMenuItem(context, '我的收藏', Icons.bookmark_border, () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const MyCollection(),
                      ),
                    );
                  }),
                  _buildMenuItem(context, '消息通知', Icons.notifications_none, () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const MyMessage(),
                      ),
                    );
                  }),
                  _buildMenuItem(context, '设置', Icons.settings, () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (context) => const Setting()),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool showBadge = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            if (showBadge)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
