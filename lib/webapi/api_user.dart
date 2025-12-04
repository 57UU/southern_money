import 'package:dio/dio.dart';
import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiUserService {
  final JwtDio jwtDio;
  ApiUserService(this.jwtDio);

  /// 更新用户信息
  Future<ApiResponse<Map<String, dynamic>>> updateUser({
    required String name,
    required String email,
  }) async {
    try {
      final request = UserUpdateRequest(name: name, email: email);

      final response = await jwtDio.post(
        UserUpdateRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "更新用户信息失败: $e");
    }
  }

  /// 修改密码
  Future<ApiResponse<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final request = UserChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      final response = await jwtDio.post(
        UserChangePasswordRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "修改密码失败: $e");
    }
  }

  /// 用户充值
  Future<ApiResponse<Map<String, dynamic>>> topup({
    required double amount,
  }) async {
    try {
      final request = UserTopupRequest(amount: amount);

      final response = await jwtDio.post(
        UserTopupRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "用户充值失败: $e");
    }
  }

  /// 开户
  Future<ApiResponse<Map<String, dynamic>>> openAccount() async {
    try {
      final request = UserOpenAccountRequest();

      final response = await jwtDio.post(UserOpenAccountRequest.route);

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "开户失败: $e");
    }
  }

  /// 上传头像
  Future<ApiResponse<AvatarUploadResponse>> uploadAvatar(
    String avatarFile,
  ) async {
    try {
      final request = UserUploadAvatarRequest();

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(avatarFile),
      });

      final response = await jwtDio.post(
        UserUploadAvatarRequest.route,
        data: formData,
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            AvatarUploadResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "上传头像失败: $e");
    }
  }

  /// 获取用户资产信息
  Future<ApiResponse<UserAssetResponse>> getUserAsset() async {
    try {
      final response = await jwtDio.get('/user/asset');

      return ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            UserAssetResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取用户资产信息失败: $e");
    }
  }

  /// 获取用户个人资料
  Future<ApiResponse<UserProfileResponse>> getUserProfile() async {
    try {
      final response = await jwtDio.get('/user/profile');

      return ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            UserProfileResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取用户个人资料失败: $e");
    }
  }
}
