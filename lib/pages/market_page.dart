
import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final storeApi = getIt<ApiStoreService>();
  List<CategoryResponse> _categories = [];
  Map<String, double> _avgPrices = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndAvgPrices();
  }

  Future<void> _loadCategoriesAndAvgPrices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 获取分类列表
      final categoryResponse = await storeApi.getCategoryList();
      if (categoryResponse.success && categoryResponse.data != null) {
        _categories = categoryResponse.data!;
        
        // 获取每个分类的均价
        for (final category in _categories) {
          final avgPriceResponse = await storeApi.getCategoryAvgPrice(category.id);
          if (avgPriceResponse.success && avgPriceResponse.data != null) {
            _avgPrices[category.id] = avgPriceResponse.data!.avgPrice;
          } else {
            _avgPrices[category.id] = 0.0;
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载行情数据失败: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMarketBar(CategoryResponse category) {
    final avgPrice = _avgPrices[category.id] ?? 0.0;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '均价: ¥${avgPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const Icon(Icons.trending_up),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: avgPrice / 10000, // 假设最大均价为10000，根据实际情况调整
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('行情'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadCategoriesAndAvgPrices();
            },
            label: const Text('刷新'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(child: Text('暂无行情数据'))
              : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return _buildMarketBar(category);
                  },
                ),
    );
  }
}