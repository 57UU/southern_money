import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/definitions_response.dart';

Future<ApiResponse<TestResponse>> testApi() async {
  try {
    final response = (await http.get(Uri.parse("${baseUrl}/test"))).body;
    final json = jsonDecode(response);
    return ApiResponse.fromJson(
      json,
      (dataJson) => TestResponse.fromJson(dataJson as Map<String, dynamic>),
    );
  } catch (e) {
    // 处理异常，返回错误响应
    return ApiResponse.fail(message: "Fail: $e");
  }
}
