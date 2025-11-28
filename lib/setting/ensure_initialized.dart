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
  getIt.registerSingletonAsync<AppConfigService>(() async {
    await getIt.isReady<SharedPreferences>();
    final appConfigService = AppConfigService(getIt<SharedPreferences>());
    await appConfigService.initalize();
    appConfigService.onBaseUrlChange = (newUrl) {
      getIt<JwtDio>().options.baseUrl = newUrl;
    };
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
  getIt.registerSingletonAsync<JwtDio>(() async {
    await getIt.isReady<AppConfigService>();
    final jwtDio = JwtDio(
      BaseOptions(baseUrl: getIt<AppConfigService>().baseUrl),
    );
    jwtDio.interceptors.add(
      JwtInterceptor(
        onTokenExpired: () async {
          getIt<AppConfigService>().clearSessionToken();
        },
      ),
    );
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
  getIt.registerSingletonAsync<ApiLoginService>(() async {
    await getIt.isReady<JwtDio>();
    return ApiLoginService(getIt<JwtDio>());
  });
  await getIt.allReady();
}
