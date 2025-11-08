import 'package:flutter/material.dart';
import 'package:southern_money/widgets/common_widget.dart';
import '../widgets/stock_card.dart';
import '../widgets/index_card.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        // 市场指数概览
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TitleText('市场指数概览'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: IndexCard(
                      name: '黄金指数',
                      value: '1923.45',
                      change: '+0.82%',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: IndexCard(
                      name: '原油指数',
                      value: '78.32',
                      change: '-1.25%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: IndexCard(
                      name: '比特币指数',
                      value: '42356.78',
                      change: '+2.36%',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: IndexCard(
                      name: '饰品指数',
                      value: '876.23',
                      change: '+0.15%',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        TitleText("商品详情"),
        // 股票列表
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(
              10,
              (index) => _buildStockCard(context, index),
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品行情'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('搜索商品')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(child: body),
    );
  }

  Widget _buildStockCard(BuildContext context, int index) {
    final List<String> stockNames = [
      '黄金',
      '原油宝',
      '比特币',
      'AK-47 | 红线',
      'AWP | 龙狙',
      '刀 | 多普勒',
      '手套 | 骷髅手套',
      'M4A4 | 咆哮',
      'USP-S | 杀戮大厦',
      'Glock-18 | 水灵',
    ];

    final List<String> stockCodes = [
      'XAU/USD',
      'OIL/USD',
      'BTC/USD',
      'AK-47 | Redline',
      'AWP | Dragon Lore',
      'Karambit | Doppler',
      'Sport Gloves | Pandora\'s Box',
      'M4A4 | Howl',
      'USP-S | Kill Confirmed',
      'Glock-18 | Water Elemental',
    ];

    // 模拟随机涨跌
    final isUp = index % 3 != 0; // 2/3的概率上涨
    final changePercent = isUp ? (index + 1) * 0.85 : -(index + 1) * 0.42;
    final price = 100 + index * 10.5;
    final changeAmount = isUp ? (index + 1) * 0.35 : -(index + 1) * 0.18;

    return StockCard(
      stockName: stockNames[index % stockNames.length],
      stockCode: stockCodes[index % stockCodes.length],
      price: price,
      changeAmount: changeAmount,
      changePercent: changePercent,
      isUp: isUp,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('查看 ${stockNames[index % stockNames.length]} 详情'),
          ),
        );
      },
    );
  }
}
