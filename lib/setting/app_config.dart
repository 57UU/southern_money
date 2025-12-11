import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---private key-----
const String _sessionTokenKey = "session_token";
const String _refreshTokenKey = "refresh_token";
const String _idKey = "id";
const String _apiBaseUrl = "api_base_url";
//-------
const String theme_color = "theme_color";
const String animation_time = "animation_time";

class TokenService {
  SharedPreferences preferences;
  TokenService(this.preferences) {
    //init
    sessionToken = ValueNotifier(preferences.getString(_sessionTokenKey));
    _refreshToken = preferences.getString(_refreshTokenKey);
    _id = preferences.getInt(_idKey);
    _addSaveCallback();
  }
  late ValueNotifier<String?> sessionToken;
  String? _refreshToken;
  void updateTokens(String sessionToken, String refreshToken, int? id) {
    _refreshToken = refreshToken;
    if (id != null) {
      _id = id;
    }
    this.sessionToken.value = sessionToken;
  }

  int? _id = null;

  String? get refreshTokenValue => _refreshToken;
  String? get sessionTokenValue => sessionToken.value;
  int? get id => _id;

  void _addSaveCallback() {
    sessionToken.addListener(() {
      if (sessionToken.value != null) {
        preferences.setString(_sessionTokenKey, sessionToken.value!);
        preferences.setString(_refreshTokenKey, _refreshToken!);
        preferences.setInt(_idKey, _id!);
      } else {
        preferences.remove(_sessionTokenKey);
        preferences.remove(_refreshTokenKey);
        preferences.remove(_idKey);
      }
    });
  }

  void clearTokens() {
    sessionToken.value = null;
    _refreshToken = null;
    _id = null;
  }
}

class PasswordService {
  SharedPreferences preferences;
  PasswordService(this.preferences) {
    //try load
    nickname = preferences.getString(_nicknameKey);
    password = preferences.getString(_passwordKey);
  }
  static const String _passwordKey = "password";
  static const String _nicknameKey = "nickname";
  String? nickname, password;
  String? get nicknameValue => nickname;
  String? get passwordValue => password;
  void updatePassword(String nickname, String password) {
    this.nickname = nickname;
    this.password = password;
    //save
    preferences.setString(_nicknameKey, nickname);
    preferences.setString(_passwordKey, password);
  }
}

class AppConfigService {
  bool forumNeedRefresh = false;
  bool discoveryNeedRefresh = false;
  void setPostsNeedRefresh() {
    forumNeedRefresh = true;
    discoveryNeedRefresh = true;
  }

  ValueNotifier<Map<String, dynamic>> appSetting = ValueNotifier({});
  TokenService tokenService;
  ValueNotifier<String?> apiBaseUrl = ValueNotifier(null);
  void Function(String newUrl)? onBaseUrlChange;

  int get animationTime => appSetting.value[animation_time]!;
  String get baseUrl => apiBaseUrl.value ?? "http://localhost:5062";
  String? get sessionTokenValue => tokenService.sessionToken.value;

  SharedPreferences preferences;
  AppConfigService(this.preferences, this.tokenService) {
    initalize();
  }
  //save
  void _addSaveCallback() {
    apiBaseUrl.addListener(() {
      onBaseUrlChange?.call(apiBaseUrl.value ?? "");
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

  dynamic getConfig(String key) {
    return appSetting.value[key];
  }

  void setConfig(String key, dynamic value) {
    appSetting.value[key] = value;
    appSetting.notifyListeners();
  }

  Future<void> clearAllData() async {
    await preferences.clear();
    initalize();
  }

  void initalize() {
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
    apiBaseUrl.value = preferences.getString(_apiBaseUrl);
    //add callback
    _addSaveCallback();
  }
}
