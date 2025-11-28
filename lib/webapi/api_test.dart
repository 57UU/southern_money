import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiTestService {
  final AppConfigService appConfigService;
  final Dio dio;
  ApiTestService(this.appConfigService, this.dio);
  Future<ApiResponse<TestResponse>> testApi() async {
    try {
      final json = (await dio.get("${appConfigService.baseUrl}/test")).data;
      return ApiResponse.fromJson(
        json,
        (dataJson) => TestResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      // 处理异常，返回错误响应
      return ApiResponse.fail(message: "Fail: $e");
    }
  }
}
