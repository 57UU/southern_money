import 'package:flutter/material.dart';
import 'package:southern_money/pages/csgo_product_detail_page.dart';
import 'package:southern_money/pages/csgo_products_create.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_store.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/router_utils.dart';
import 'package:southern_money/widgets/styled_card.dart';

class CsgoProductsByCategory extends StatefulWidget {
  final String categoryId;
  final String? categoryName;

  const CsgoProductsByCategory({
    super.key,
    required this.categoryId,
    this.categoryName,
  });

  @override
  State<CsgoProductsByCategory> createState() => _CsgoProductsByCategoryState();
}

class _CsgoProductsByCategoryState extends State<CsgoProductsByCategory> {
  final ApiStoreService _apiStoreService = getIt<ApiStoreService>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ProductResponse> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMore) {
        _fetchProducts();
      }
    }
  }

  Future<void> _fetchProducts({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _currentPage = 1;
        _products.clear();
        _hasMore = true;
        _errorMessage = null;
      }
    });

    try {
      final response = await _apiStoreService.getProductList(
        page: _currentPage,
        pageSize: _pageSize,
        categoryId: widget.categoryId,
        search: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
      );

      if (response.success && response.data != null) {
        final pagedResponse = response.data!;
        setState(() {
          if (isRefresh) {
            _products = pagedResponse.items;
          } else {
            _products.addAll(pagedResponse.items);
          }

          _hasMore = pagedResponse.items.length == _pageSize;
          _currentPage++;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? '获取产品列表失败';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '网络错误: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchProducts() async {
    _fetchProducts(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName ?? '产品列表'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              final result = popupOrNavigate(
                context,
                CsgoProductsCreate(categoryId: widget.categoryId),
              );
              if (result == true) {
                _fetchProducts(isRefresh: true);
              }
            },
            label: Text("发布"),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索产品...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) => _searchProducts(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchProducts,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_products.isEmpty && !_isLoading) {
      return _buildEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: () => _fetchProducts(isRefresh: true),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _products.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length) {
            return _buildLoadingIndicator();
          }
          return _buildProductItem(_products[index]);
        },
      ),
    );
  }

  Widget _buildProductItem(ProductResponse product) {
    return StyledCard(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      onTap: () => {
        popupOrNavigate(context, CsgoProductDetailPage(productId: product.id)),
      },
      child: ListTile(
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¥${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '分类: ${product.categoryName}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
            ),
            Text(
              '上传者: ${product.uploaderName}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('暂无产品', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(fontSize: 16, color: Colors.red[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _fetchProducts(isRefresh: true),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
