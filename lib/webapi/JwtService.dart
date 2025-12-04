import 'package:dio/dio.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/api_login.dart';
import 'package:southern_money/webapi/jwt_dio/jwt_dio_native.dart'
    if (dart.library.js_interop) 'package:southern_money/webapi/jwt_dio/jwt_dio_web.dart';

class JwtInterceptor extends Interceptor {
  final Future<void> Function() onTokenExpired;
  final TokenService tokenService;
  final ApiLoginService apiLoginService;
  bool _isRefreshing = false;
  final List<_RetryRequest> _retryQueue = [];

  JwtInterceptor({
    required this.onTokenExpired,
    required this.tokenService,
    required this.apiLoginService,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final sessionToken = tokenService.sessionTokenValue;
    if (sessionToken != null) {
      options.headers["Authorization"] = "Bearer $sessionToken";
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理 token 过期错误
    if (_isTokenExpiredError(err)) {
      // 如果已经在刷新中，将请求加入队列
      if (_isRefreshing) {
        _retryQueue.add(_RetryRequest(err.requestOptions!, handler));
        return;
      }

      _isRefreshing = true;

      try {
        // 尝试刷新token
        final refreshToken = tokenService.refreshTokenValue;
        if (refreshToken != null) {
          try {
            final newTokens = await apiLoginService.refreshToken(refreshToken);
            tokenService.updateTokens(newTokens.$1, newTokens.$2);

            // 重试所有排队的请求
            for (final retry in _retryQueue) {
              _retryRequest(retry.options, retry.handler);
            }
            _retryQueue.clear();

            // 重试当前请求
            _retryRequest(err.requestOptions!, handler);
            return;
          } catch (e) {
            // 刷新token失败，继续执行下面的逻辑
          }
        } else {
          // 没有refresh token
        }
      } catch (e) {
        // 刷新token失败
      } finally {
        _isRefreshing = false;
        _retryQueue.clear();
      }

      // 如果刷新失败或没有refresh token，触发token过期回调
      await onTokenExpired();
    }

    return super.onError(err, handler);
  }

  void _retryRequest(RequestOptions options, ErrorInterceptorHandler handler) {
    // 更新请求头中的token
    final sessionToken = tokenService.sessionTokenValue;
    if (sessionToken != null) {
      options.headers["Authorization"] = "Bearer $sessionToken";
    }

    // 创建新的请求
    final cloneReq = options;
    handler.resolve(
      Response(requestOptions: cloneReq, data: null, statusCode: 200),
    );
  }

  bool _isTokenExpiredError(DioException err) {
    return err.response?.statusCode == 401;
  }
}

class _RetryRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RetryRequest(this.options, this.handler);
}

abstract class JwtDio implements Dio {
  factory JwtDio(BaseOptions? baseOptions) => createJwtDio(baseOptions);
}
