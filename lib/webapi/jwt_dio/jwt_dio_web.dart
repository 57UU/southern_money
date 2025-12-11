import 'package:dio/browser.dart' show DioForBrowser;
import 'package:dio/dio.dart';
import 'package:southern_money/webapi/JwtService.dart';

class _jwtDioBrowser extends DioForBrowser implements JwtDio {
  _jwtDioBrowser(BaseOptions? baseOptions) : super(baseOptions);
}

JwtDio createJwtDio(BaseOptions? baseOptions) => _jwtDioBrowser(baseOptions);
