import 'package:dio/dio.dart';
import 'package:dio/io.dart' show DioForNative;
import 'package:southern_money/webapi/JwtService.dart';


class _jwtDio extends DioForNative implements JwtDio {
  _jwtDio(BaseOptions? baseOptions) : super(baseOptions);
}

JwtDio createJwtDio(BaseOptions? baseOptions) => _jwtDio(baseOptions);