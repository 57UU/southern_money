import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<Map<String, dynamic>> appSetting = ValueNotifier({});
ValueNotifier<String?> sessionToken = ValueNotifier(null);

bool isFirstTime = true;

const String _sessionTokenKey = "session_token";
const String theme_color = "theme_color";
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

  appSetting.addListener(() {
    preferences.setInt(theme_color, appSetting.value[theme_color]!.value);
  });
}

void clearAllData() async {
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
  sessionToken.value = preferences.getString(_sessionTokenKey);
}
