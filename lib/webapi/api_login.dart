import 'package:dio/dio.dart';
import 'package:southern_money/setting/app_config.dart';

class ApiLoginService {
  final Dio dio;
  final AppConfigService appConfigService;
  ApiLoginService(this.dio, this.appConfigService);

  Future<(String token, String refreshToken)> login(
    String username,
    String password,
  ) async {
    throw UnimplementedError();
  }

  Future<(String token, String refreshToken)> refreshToken(
    String refreshToken,
  ) async {
    throw UnimplementedError();
  }
}
