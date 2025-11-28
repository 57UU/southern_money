import 'package:dio/dio.dart';
import 'package:dio/io.dart' show DioForNative;
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/setting/ensure_initialized.dart';

class JwtInterceptor extends Interceptor {
  final Future<void> Function() onTokenExpired;

  JwtInterceptor({required this.onTokenExpired});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final appConfigService = getIt<AppConfigService>();
    final sessionToken = appConfigService.sessionTokenValue;
    if (sessionToken != null) {
      options.headers["Authorization"] = "Bearer $sessionToken";
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理 token 过期错误
    if (_isTokenExpiredError(err)) {
      await onTokenExpired();
    }

    return super.onError(err, handler);
  }

  bool _isTokenExpiredError(DioException err) {
    return err.response?.statusCode == 401;
  }
}

abstract class JwtDio implements Dio {
  factory JwtDio(BaseOptions? baseOptions) => _jwtDio(baseOptions);
}

class _jwtDio extends DioForNative implements JwtDio {
  _jwtDio(BaseOptions? baseOptions) : super(baseOptions);
}
