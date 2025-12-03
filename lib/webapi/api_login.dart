import 'package:dio/dio.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiLoginService {
  final Dio dio;
  final AppConfigService appConfigService;
  ApiLoginService(this.dio, this.appConfigService);

  Future<(String token, String refreshToken)> login(
    String username,
    String password,
  ) async {
    try {
      final response = await dio.post(
        "${appConfigService.baseUrl}${LoginByPasswordRequest.route}",
        data: LoginByPasswordRequest(
          username: username,
          password: password,
        ).toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            LoginByPasswordResponse.fromJson(dataJson as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return (apiResponse.data!.token, apiResponse.data!.refreshToken);
      } else {
        throw Exception(apiResponse.message ?? "登录失败");
      }
    } catch (e) {
      throw Exception("登录请求失败: $e");
    }
  }

  Future<(String token, String refreshToken)> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await dio.post(
        "${appConfigService.baseUrl}${RefreshTokenRequest.route}",
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            RefreshTokenResponse.fromJson(dataJson as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return (apiResponse.data!.token, apiResponse.data!.refreshToken);
      } else {
        throw Exception(apiResponse.message ?? "刷新令牌失败");
      }
    } catch (e) {
      throw Exception("刷新令牌请求失败: $e");
    }
  }
}
