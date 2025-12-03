import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiTransactionService {
  final JwtDio jwtDio;
  ApiTransactionService(this.jwtDio);

  /// 购买产品
  Future<ApiResponse<Map<String, dynamic>>> buyProduct(String productId) async {
    try {
      final request = TransactionBuyRequest(productId: productId);
      
      final response = await jwtDio.post(
        TransactionBuyRequest.route,
        data: request.toJson(),
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "购买产品失败: $e");
    }
  }

  /// 获取我的交易记录
  Future<ApiResponse<PagedResponse<TransactionRecordResponse>>> getMyTransactionRecords({
    required int page,
    required int pageSize,
  }) async {
    try {
      final request = TransactionMyRecordsRequest(page: page, pageSize: pageSize);
      
      final response = await jwtDio.get(
        TransactionMyRecordsRequest.route,
        queryParameters: {
          'page': request.page,
          'pageSize': request.pageSize,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) => TransactionRecordResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取交易记录失败: $e");
    }
  }
}