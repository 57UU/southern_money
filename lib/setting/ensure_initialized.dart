import 'dart:ui' show DartPluginRegistrant;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';
import 'version.dart';

Future<void> ensureInitialize() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
  }
  preferences = await SharedPreferences.getInstance();
  await Future.wait([initVersion(), loadConfig()]);
  addSaveCallback();
}
