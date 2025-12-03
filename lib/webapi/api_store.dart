import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiStoreService {
  final JwtDio jwtDio;
  ApiStoreService(this.jwtDio);

  /// 发布产品
  Future<ApiResponse<Map<String, dynamic>>> publishProduct({
    required String name,
    required double price,
    required String description,
    required String categoryId,
  }) async {
    try {
      final request = ProductPublishRequest(
        name: name,
        price: price,
        description: description,
        categoryId: categoryId,
      );
      
      final response = await jwtDio.post(
        ProductPublishRequest.route,
        data: request.toJson(),
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "发布产品失败: $e");
    }
  }

  /// 删除产品
  Future<ApiResponse<Map<String, dynamic>>> deleteProduct(String productId) async {
    try {
      final request = ProductDeleteRequest(productId: productId);
      
      final response = await jwtDio.post(
        ProductDeleteRequest.route,
        data: request.toJson(),
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "删除产品失败: $e");
    }
  }

  /// 获取产品详情
  Future<ApiResponse<ProductDetailResponse>> getProductDetail(String productId) async {
    try {
      final request = ProductDetailRequest(productId: productId);
      
      final response = await jwtDio.get(
        ProductDetailRequest.route,
        queryParameters: {'id': request.productId},
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => ProductDetailResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取产品详情失败: $e");
    }
  }

  /// 获取产品列表
  Future<ApiResponse<PagedResponse<ProductResponse>>> getProductList({
    required int page,
    required int pageSize,
    String? categoryId,
    String? search,
  }) async {
    try {
      final request = ProductListRequest(
        page: page,
        pageSize: pageSize,
        categoryId: categoryId,
        search: search,
      );
      
      final queryParams = <String, dynamic>{
        'page': request.page,
        'pageSize': request.pageSize,
      };
      
      if (request.categoryId != null) {
        queryParams['categoryId'] = request.categoryId;
      }
      
      if (request.search != null) {
        queryParams['search'] = request.search;
      }
      
      final response = await jwtDio.get(
        ProductListRequest.route,
        queryParameters: queryParams,
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) => ProductResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取产品列表失败: $e");
    }
  }

  /// 获取分类下的产品列表
  Future<ApiResponse<PagedResponse<ProductResponse>>> getProductCategoryList({
    required String id,
    required int page,
    required int pageSize,
  }) async {
    try {
      final request = ProductCategoryListRequest(
        id: id,
        page: page,
        pageSize: pageSize,
      );
      
      final response = await jwtDio.get(
        ProductCategoryListRequest.route,
        queryParameters: {
          'id': request.id,
          'page': request.page,
          'pageSize': request.pageSize,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) => ProductResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取分类产品列表失败: $e");
    }
  }

  /// 搜索产品
  Future<ApiResponse<PagedResponse<ProductResponse>>> searchProducts({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    try {
      final request = ProductSearchRequest(
        q: query,
        page: page,
        pageSize: pageSize,
      );
      
      final response = await jwtDio.get(
        ProductSearchRequest.route,
        queryParameters: {
          'q': request.q,
          'page': request.page,
          'pageSize': request.pageSize,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) => ProductResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "搜索产品失败: $e");
    }
  }

  /// 获取我的产品
  Future<ApiResponse<PagedResponse<ProductResponse>>> getMyProducts({
    required int page,
    required int pageSize,
  }) async {
    try {
      final request = MyProductsRequest(page: page, pageSize: pageSize);
      
      final response = await jwtDio.get(
        MyProductsRequest.route,
        queryParameters: {
          'page': request.page,
          'pageSize': request.pageSize,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) => ProductResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取我的产品失败: $e");
    }
  }

  /// 获取分类列表
  Future<ApiResponse<List<CategoryResponse>>> getCategoryList() async {
    try {
      final request = CategoryListRequest();
      
      final response = await jwtDio.get(
        CategoryListRequest.route,
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => (dataJson as List)
            .map((item) => CategoryResponse.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取分类列表失败: $e");
    }
  }

  /// 获取分类详情
  Future<ApiResponse<CategoryResponse>> getCategoryDetail(String id) async {
    try {
      final request = CategoryGetRequest(id: id);
      
      final response = await jwtDio.get(
        CategoryGetRequest.route,
        queryParameters: {'id': request.id},
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => CategoryResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取分类详情失败: $e");
    }
  }

  /// 搜索分类
  Future<ApiResponse<CategorySearchResponse>> searchCategories(String name) async {
    try {
      final request = CategorySearchRequest(name: name);
      
      final response = await jwtDio.get(
        CategorySearchRequest.route,
        queryParameters: {'name': request.name},
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => CategorySearchResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "搜索分类失败: $e");
    }
  }

  /// 创建分类
  Future<ApiResponse<Map<String, dynamic>>> createCategory({
    required String category,
    required String cover,
  }) async {
    try {
      final request = CategoryCreateRequest(
        category: category,
        cover: cover,
      );
      
      final response = await jwtDio.post(
        CategoryCreateRequest.route,
        data: request.toJson(),
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "创建分类失败: $e");
    }
  }

  /// 收藏分类
  Future<ApiResponse<Map<String, dynamic>>> favoriteCategory(String categoryId) async {
    try {
      final request = CategoryFavoriteRequest(categoryId: categoryId);
      
      final response = await jwtDio.post(
        CategoryFavoriteRequest.route,
        queryParameters: {'categoryId': request.categoryId},
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "收藏分类失败: $e");
    }
  }

  /// 取消收藏分类
  Future<ApiResponse<Map<String, dynamic>>> unfavoriteCategory(String categoryId) async {
    try {
      final request = CategoryUnfavoriteRequest(categoryId: categoryId);
      
      final response = await jwtDio.delete(
        CategoryUnfavoriteRequest.route,
        queryParameters: {'categoryId': request.categoryId},
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "取消收藏分类失败: $e");
    }
  }

  /// 获取收藏的分类
  Future<ApiResponse<List<CategoryResponse>>> getFavoriteCategories() async {
    try {
      final request = FavoriteCategoriesRequest();
      
      final response = await jwtDio.get(
        FavoriteCategoriesRequest.route,
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => (dataJson as List)
            .map((item) => CategoryResponse.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取收藏分类失败: $e");
    }
  }

  /// 检查是否已收藏分类
  Future<ApiResponse<CheckFavoritedResponse>> checkFavorited(String categoryId) async {
    try {
      final request = CheckFavoritedRequest(categoryId: categoryId);
      
      final response = await jwtDio.get(
        CheckFavoritedRequest.route,
        queryParameters: {'categoryId': request.categoryId},
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => CheckFavoritedResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "检查收藏状态失败: $e");
    }
  }

  /// 获取分类平均价格
  Future<ApiResponse<AvgPriceResponse>> getCategoryAvgPrice(String categoryId) async {
    try {
      final request = CategoryAvgPriceRequest(categoryId: categoryId);
      
      final response = await jwtDio.get(
        CategoryAvgPriceRequest.route,
        queryParameters: {'categoryId': request.categoryId},
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => AvgPriceResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取分类平均价格失败: $e");
    }
  }
}