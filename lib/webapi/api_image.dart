import 'dart:io';
import 'package:dio/dio.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiImageService {
  final JwtDio jwtDio;
  final AppConfigService appConfigService;
  ApiImageService(this.jwtDio, this.appConfigService);

  /// 上传图片
  Future<ApiResponse<ImageUploadResponse>> uploadImage({
    required File imageFile,
    required String imageType,
    String? description,
  }) async {
    try {
      final request = ImageUploadRequest(
        imageType: imageType,
        description: description,
      );

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
        'imageType': request.imageType,
        if (request.description != null) 'description': request.description,
      });

      final response = await jwtDio.post(
        ImageUploadRequest.route,
        data: formData,
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            ImageUploadResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "上传图片失败: $e");
    }
  }

  String getImageUrl(String imageId) {
    return "${appConfigService.baseUrl}${ImageGetRequest.route}?id=$imageId";
  }

  /// 获取图片
  Future<ApiResponse<ImageGetResponse>> getImage(String imageId) async {
    try {
      final request = ImageGetRequest(imageId: imageId);

      final response = await jwtDio.get(
        ImageGetRequest.route,
        queryParameters: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            ImageGetResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取图片失败: $e");
    }
  }
}
