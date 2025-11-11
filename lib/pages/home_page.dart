import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/jewelry_page.dart';

import '../widgets/post_card.dart';
import 'open_an_account.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('南方财富'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [QuickNavigation(), Discovery()],
          ),
        ),
      ),
    );
  }
}

class Discovery extends StatefulWidget {
  const Discovery({super.key});

  @override
  State<Discovery> createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('发现', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        PostCard(
          title: '重磅利好来袭！国办发文 事关新场景大规模应用',
          author: '证券时报网',
          timeAgo: '1小时前',
        ),
        PostCard(
          title: 'CSGO饰品市场分析：龙狙价格创历史新高',
          author: '游戏投资分析师',
          timeAgo: '2小时前',
        ),
        PostCard(title: '黄金下破3930美元，发生什么事了？', author: "派大星皮皮", timeAgo: '3小时前'),
      ],
    );
  }
}

class QuickNavigation extends StatelessWidget {
  const QuickNavigation({super.key});

  Widget _buildCardButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '快速导航',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: _buildCardButton(
                icon: Icons.account_balance,
                label: '开户',
                color: Colors.blue,
                onTap: () {
                  // 处理开户点击事件
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const OpenAnAccount(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: _buildCardButton(
                icon: Icons.videogame_asset,
                label: 'CSGO饰品',
                color: Colors.purple,
                onTap: () {
                  // 处理CSGO饰品点击事件
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const JewelryPage(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: _buildCardButton(
                icon: Icons.trending_up,
                label: '期货',
                color: Colors.green,
                onTap: () {
                  // 处理期货点击事件
                },
              ),
            ),
            Expanded(
              child: _buildCardButton(
                icon: Icons.monetization_on,
                label: '黄金',
                color: Colors.amber,
                onTap: () {
                  // 处理黄金点击事件
                },
              ),
            ),
            Expanded(
              child: _buildCardButton(
                icon: Icons.attach_money,
                label: '虚拟货币',
                color: Colors.orange,
                onTap: () {
                  // 处理股票点击事件
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
