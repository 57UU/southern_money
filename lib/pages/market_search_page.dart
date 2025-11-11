import 'package:flutter/material.dart';
import '../setting/app_config.dart';
import '../widgets/stock_card.dart';

class MarketSearchPage extends StatefulWidget {
  const MarketSearchPage({super.key});

  @override
  State<MarketSearchPage> createState() => _MarketSearchPageState();
}

class _MarketSearchPageState extends State<MarketSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<_StockData> _filteredStocks = [];
  List<_StockData> _allStocks = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // 初始化股票数据
    _initializeStockData();
    _filteredStocks = _allStocks;
  }

  void _initializeStockData() {
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

    _allStocks = List.generate(stockNames.length, (index) {
      final isUp = index % 3 != 0;
      final changePercent = isUp ? (index + 1) * 0.85 : -(index + 1) * 0.42;
      final price = 100 + index * 10.5;
      final changeAmount = isUp ? (index + 1) * 0.35 : -(index + 1) * 0.18;

      return _StockData(
        name: stockNames[index],
        code: stockCodes[index],
        price: price,
        changeAmount: changeAmount,
        changePercent: changePercent,
        isUp: isUp,
      );
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _isSearching = true;
      if (query.isEmpty) {
        _filteredStocks = _allStocks;
      } else {
        _filteredStocks = _allStocks.where((stock) {
          return stock.name.toLowerCase().contains(query.toLowerCase()) ||
              stock.code.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: SearchBar(
          controller: _searchController,
          hintText: '搜索商品行情',
          leading: const Icon(Icons.search),
          onChanged: (value) {
            _handleSearch(value);
          },
          onSubmitted: (value) {
            _handleSearch(value);
          },
          onTap: () {
            // Handle tap event
          },
          trailing: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _handleSearch('');
                },
                splashRadius: 18,
              ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              '取消',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: animationTime),
        curve: Curves.easeOutQuart,
        child: _isSearching
            ? _filteredStocks.isEmpty
                ? Center(
                    child: Text(
                      '未找到相关商品',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredStocks.length,
                    itemBuilder: (context, index) {
                      final stock = _filteredStocks[index];
                      return StockCard(
                        stockName: stock.name,
                        stockCode: stock.code,
                        price: stock.price,
                        changeAmount: stock.changeAmount,
                        changePercent: stock.changePercent,
                        isUp: stock.isUp,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('查看 ${stock.name} 详情'),
                            ),
                          );
                        },
                      );
                    },
                  )
            : Center(
                child: Text(
                  '请输入关键词搜索商品行情',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
      ),
    );
  }
}

class _StockData {
  final String name;
  final String code;
  final double price;
  final double changeAmount;
  final double changePercent;
  final bool isUp;

  _StockData({
    required this.name,
    required this.code,
    required this.price,
    required this.changeAmount,
    required this.changePercent,
    required this.isUp,
  });
}