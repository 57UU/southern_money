import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiAdminService {
  final JwtDio jwtDio;
  ApiAdminService(this.jwtDio);

  /// 获取所有用户列表
  Future<ApiResponse<PagedResponse<AdminUserResponse>>> getAllUsers({
    required AdminUsersRequest request,
  }) async {
    try {
      final response = await jwtDio.get(
        AdminUsersRequest.route,
        queryParameters: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) =>
              AdminUserResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取用户列表失败: $e");
    }
  }

  /// 处理用户状态（启用/禁用）
  Future<ApiResponse<Map<String, dynamic>>> handleUserStatus({
    required int userId,
    required bool isBlocked,
    required String handleReason,
  }) async {
    try {
      final request = AdminHandleUserRequest(
        userId: userId,
        isBlocked: isBlocked,
        handleReason: handleReason,
      );

      final response = await jwtDio.post(
        AdminHandleUserRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "处理用户状态失败: $e");
    }
  }

  /// 获取所有被举报帖子列表
  Future<ApiResponse<PagedResponse<PostPageItemResponse>>> getAllPosts({
    required int page,
    required int pageSize,
    required bool isBlocked,
  }) async {
    try {
      final request = AdminReportedPostsRequest(
        page: page,
        pageSize: pageSize,
        isBlocked: isBlocked,
      );

      final response = await jwtDio.get(
        AdminReportedPostsRequest.route,
        queryParameters: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) =>
              PostPageItemResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取举报帖子列表失败: $e");
    }
  }

  /// 处理举报帖子
  Future<ApiResponse<Map<String, dynamic>>> handleReport({
    required String postId,
    required bool isBlocked,
    required String handleReason,
  }) async {
    try {
      final request = AdminHandleReportRequest(
        postId: postId,
        isBlocked: isBlocked,
        handleReason: handleReason,
      );

      final response = await jwtDio.post(
        AdminHandleReportRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "处理举报帖子失败: $e");
    }
  }

  Future<ApiResponse> setAdmin({
    required int userId,
    required bool isAdmin,
  }) async {
    try {
      final request = SetAdminRequest(userId: userId, isAdmin: isAdmin);

      final response = await jwtDio.post(
        SetAdminRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "设置管理员状态失败: $e");
    }
  }
}
