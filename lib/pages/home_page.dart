import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/jewelry_page.dart';
import 'package:southern_money/pages/futures_page.dart';
import 'package:southern_money/pages/gold_page.dart';
import 'package:southern_money/pages/crypto_currency_page.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_post.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/router_utils.dart';

import '../widgets/post_card.dart';
import 'open_an_account.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以使 AutomaticKeepAliveClientMixin 生效
    return Scaffold(
      appBar: AppBar(title: const Text('南方财富'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const QuickNavigation(), const Discovery()],
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
// get post by hr
class _DiscoveryState extends State<Discovery> {
  final postService = getIt<ApiPostService>();

  late Future<ApiResponse<PagedResponse<PostPageItemResponse>>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = postService.getPostPage(page: 0, pageSize: 3);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponse<PagedResponse<PostPageItemResponse>>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text("加载失败");
        }

        final response = snapshot.data!;

        if (!response.success || response.data == null) {
          return Text("获取帖子失败：${response.message}");
        }

        final posts = response.data!.items;

        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '发现',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            // 🔥 从后端渲染动态帖子（只显示 content + author）
            for (var p in posts)
              PostCard(
                title: p.content, // ← 显示内容
                author: p.uploader.name, // ← 显示作者
                timeAgo: "", // ← 你不需要时间，传空字符串
              ),
          ],
        );
      },
    );
  }
}
// get post finish by hr


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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCardButton(
              icon: Icons.account_balance,
              label: '开户',
              color: Colors.blue,
              onTap: () {
                // 处理开户点击事件
                popupOrNavigate(context, const OpenAnAccount());
              },
            ),
            _buildCardButton(
              icon: Icons.videogame_asset,
              label: 'CSGO饰品',
              color: Colors.purple,
              onTap: () {
                // 处理CSGO饰品点击事件
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const JewelryPage()),
                );
              },
            ),
            _buildCardButton(
              icon: Icons.trending_up,
              label: '期货',
              color: Colors.green,
              onTap: () {
                // 处理期货点击事件
                popupOrNavigate(context, const FuturesPage());
              },
            ),
            _buildCardButton(
              icon: Icons.monetization_on,
              label: '黄金',
              color: Colors.amber,
              onTap: () {
                // 处理黄金点击事件
                popupOrNavigate(context, const GoldPage());
              },
            ),
            _buildCardButton(
              icon: Icons.attach_money,
              label: '虚拟货币',
              color: Colors.orange,
              onTap: () {
                // 处理虚拟货币点击事件
                popupOrNavigate(context, const CryptoCurrencyPage());
              },
            ),
          ],
        ),
      ],
    );
  }
}
