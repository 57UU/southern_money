import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/community_search_page.dart';
import 'package:southern_money/pages/post_page.dart';
import '../widgets/post_card.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('社区'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const CommunitySearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const PostPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 帖子列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildPostCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, int index) {
    final List<String> titles = [
      '今日大盘走势分析，明天会继续上涨吗？',
      'CSGO饰品市场分析：龙狙价格走势预测',
      '分享我的投资组合，年化收益率15%',
      'CSGO开箱技巧：提高获得稀有皮肤概率',
      '价值投资VS成长投资，哪种更适合你？',
      'CSGO饰品投资入门：如何挑选有潜力的皮肤',
      '基金定投真的能赚钱吗？',
      'CSGO饰品交易平台对比：Steam、Buff、IGXE哪个更划算？',
      '我的投资失败经历与反思',
      '如何做好资产配置，降低投资风险？',
    ];

    final List<String> authors = [
      '投资达人',
      'CSGO饰品分析师',
      '理财专家',
      '开箱大师',
      '价值投资者',
      '饰品收藏家',
      '基金达人',
      '交易达人',
      '理性投资者',
      '资产配置师',
    ];

    return PostCard(
      title: titles[index % titles.length],
      author: authors[index % authors.length],
      timeAgo: '${index + 1}小时前',
    );
  }
}
