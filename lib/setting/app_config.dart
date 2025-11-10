import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<Map<String, dynamic>> appSetting = ValueNotifier({});

bool isFirstTime = true;

const String theme_color = "theme_color";
late SharedPreferences preferences;

Future<void> saveAppSetting() async {
  preferences.setInt(theme_color, appSetting.value[theme_color]!.value);

}

Future<void> loadConfig() async {
  int? color = preferences.getInt(theme_color);
  if (color == null) {
    appSetting.value[theme_color] = Colors.blue;
  } else {
    appSetting.value[theme_color] = Color(color);
  }
}