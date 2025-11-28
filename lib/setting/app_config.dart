import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<Map<String, dynamic>> appSetting = ValueNotifier({});
ValueNotifier<String?> sessionToken = ValueNotifier(null);
ValueNotifier<String?> apiBaseUrl = ValueNotifier(null);

int get animationTime => appSetting.value[animation_time]!;
String get baseUrl => apiBaseUrl.value ?? "http://localhost:5062";
// ---private key-----
const String _sessionTokenKey = "session_token";
const String _apiBaseUrl = "api_base_url";
//-------
const String theme_color = "theme_color";
const String animation_time = "animation_time";
late SharedPreferences preferences;
//save
void addSaveCallback() {
  sessionToken.addListener(() {
    if (sessionToken.value != null) {
      preferences.setString(_sessionTokenKey, sessionToken.value!);
    } else {
      preferences.remove(_sessionTokenKey);
    }
  });
  apiBaseUrl.addListener(() {
    if (apiBaseUrl.value != null) {
      preferences.setString(_apiBaseUrl, apiBaseUrl.value!);
    } else {
      preferences.remove(_apiBaseUrl);
    }
  });

  appSetting.addListener(() {
    preferences.setInt(theme_color, appSetting.value[theme_color]!.value);
    preferences.setInt(animation_time, appSetting.value[animation_time]!);
  });
}

Future<void> clearAllData() async {
  await preferences.clear();
  await loadConfig();
}

Future<void> loadConfig() async {
  int? color = preferences.getInt(theme_color);
  if (color == null) {
    appSetting.value[theme_color] = Colors.blue;
  } else {
    appSetting.value[theme_color] = Color(color);
  }
  int? animationTime = preferences.getInt(animation_time);
  if (animationTime == null) {
    appSetting.value[animation_time] = 350;
  } else {
    appSetting.value[animation_time] = animationTime;
  }
  sessionToken.value = preferences.getString(_sessionTokenKey);
  apiBaseUrl.value = preferences.getString(_apiBaseUrl);
}
