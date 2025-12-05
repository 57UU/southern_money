import 'dart:io';
import 'package:dio/dio.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiImageService {
  final JwtDio jwtDio;
  final Dio dio;
  final AppConfigService appConfigService;
  ApiImageService(this.jwtDio, this.dio, this.appConfigService);

  /// 上传图片
  Future<ApiResponse<ImageUploadResponse>> uploadImage({
    required File imageFile,
    String imageType = "image/jpeg",
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

  /// Web平台上传图片
  Future<ApiResponse<ImageUploadResponse>> uploadImageWeb({
    required String imagePath,
    String imageType = "image/jpeg",
    String? description,
  }) async {
    try {
      // 在Web平台上，imagePath是一个blob URL
      // 我们需要将其转换为适合上传的格式
      if (imagePath.startsWith('blob:')) {
        // 如果是blob URL，我们需要先获取图片数据
        final response = await dio.get(
          imagePath,
          options: Options(responseType: ResponseType.bytes),
        );

        final formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            response.data,
            filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
          'imageType': imageType,
          if (description != null) 'description': description,
        });

        final uploadResponse = await jwtDio.post(
          ImageUploadRequest.route,
          data: formData,
        );

        return ApiResponse.fromJson(
          uploadResponse.data,
          (dataJson) =>
              ImageUploadResponse.fromJson(dataJson as Map<String, dynamic>),
        );
      } else {
        return ApiResponse.fail(message: "不支持的图片路径格式");
      }
    } catch (e) {
      return ApiResponse.fail(message: "Web平台上传图片失败: $e");
    }
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
