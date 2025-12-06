import 'package:dio/dio.dart';
import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiNotificationService {
  final JwtDio jwtDio;

  ApiNotificationService(this.jwtDio);

  /// 获取我的通知列表
  Future<ApiResponse<PagedResponse<NotificationResponse>>> getMyNotifications({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final request = NotificationMyRequest(page: page, pageSize: pageSize);

      final response = await jwtDio.get(
        NotificationMyRequest.route,
        queryParameters: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) =>
              NotificationResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取通知列表失败: $e");
    }
  }

  /// 获取未读通知数量
  Future<ApiResponse<int>> getUnreadCount() async {
    try {
      final response = await jwtDio.get(NotificationUnreadCountRequest.route);

      return ApiResponse.fromJson(response.data, (dataJson) => dataJson as int);
    } catch (e) {
      return ApiResponse.fail(message: "获取未读通知数量失败: $e");
    }
  }

  /// 标记通知为已读
  Future<ApiResponse<Map<String, dynamic>>> markAsRead({
    required List<String> notificationIds,
  }) async {
    try {
      final request = NotificationMarkReadRequest(
        notificationIds: notificationIds,
      );

      final response = await jwtDio.post(
        NotificationMarkReadRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "标记通知为已读失败: $e");
    }
  }

  /// 标记所有通知为已读
  Future<ApiResponse<Map<String, dynamic>>> markAllAsRead() async {
    try {
      final response = await jwtDio.post(NotificationReadAllRequest.route);

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "标记所有通知为已读失败: $e");
    }
  }
}
