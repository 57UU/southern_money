import 'dart:ui' show DartPluginRegistrant;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/index.dart';

import 'app_config.dart';
import 'version.dart';

final getIt = GetIt.instance;

Future<void> ensureInitialize() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
  }
  getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  getIt.registerSingletonAsync<TokenService>(() async {
    await getIt.isReady<SharedPreferences>();
    final tokenService = TokenService(getIt<SharedPreferences>());
    return tokenService;
  });
  getIt.registerSingletonAsync<AppConfigService>(() async {
    await getIt.isReady<TokenService>();
    final appConfigService = AppConfigService(
      getIt<SharedPreferences>(),
      getIt<TokenService>(),
    );
    // 注意：onBaseUrlChange 回调将在 JwtDio 注册后设置
    return appConfigService;
  });
  getIt.registerSingletonAsync<PackageInfo>(() async {
    return await PackageInfo.fromPlatform();
  });
  getIt.registerSingletonAsync<VersionService>(() async {
    await getIt.isReady<PackageInfo>();
    return VersionService(getIt<PackageInfo>());
  });
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingletonAsync<ApiLoginService>(() async {
    await getIt.isReady<AppConfigService>();
    return ApiLoginService(getIt<Dio>(), getIt<AppConfigService>());
  });
  getIt.registerSingletonAsync<JwtDio>(() async {
    await getIt.isReady<AppConfigService>();
    await getIt.isReady<ApiLoginService>();
    final jwtDio = JwtDio(
      BaseOptions(baseUrl: getIt<AppConfigService>().baseUrl),
    );
    jwtDio.interceptors.add(
      JwtInterceptor(
        onTokenExpired: () async {
          getIt<TokenService>().clearTokens();
        },
        tokenService: getIt<TokenService>(),
        apiLoginService: getIt<ApiLoginService>(),
      ),
    );

    // 设置 AppConfigService 的 onBaseUrlChange 回调，现在 JwtDio 已经注册
    getIt<AppConfigService>().onBaseUrlChange = (newUrl) {
      jwtDio.options.baseUrl = newUrl;
    };

    return jwtDio;
  });
  getIt.registerSingletonAsync<ApiTestService>(() async {
    await getIt.isReady<AppConfigService>();
    return ApiTestService(getIt<AppConfigService>(), getIt<Dio>());
  });
  getIt.registerSingletonAsync<ApiPostService>(() async {
    await getIt.isReady<JwtDio>();
    return ApiPostService(getIt<JwtDio>());
  });

  await getIt.allReady();
}
