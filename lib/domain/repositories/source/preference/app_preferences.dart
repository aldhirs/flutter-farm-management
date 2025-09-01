import 'dart:convert';

import 'package:farm/base/log/mixin/log_mixin.dart';
import 'package:farm/constants/shared_preference_constants.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class AppPreferences with LogMixin {
  AppPreferences(this._sharedPreference);

  final SharedPreferences _sharedPreference;

  bool get isDarkMode {
    return _sharedPreference.getBool(SharedPreferenceKeys.isDarkMode) ?? false;
  }

  String get deviceToken {
    return _sharedPreference.getString(SharedPreferenceKeys.deviceToken) ?? '';
  }

  String get languageCode =>
      _sharedPreference.getString(SharedPreferenceKeys.languageCode) ?? '';

  int get appsVersionCodeSaved {
    return _sharedPreference.getInt(
          SharedPreferenceKeys.appsVersionCodeSaved,
        ) ??
        0;
  }

  Future<String> get accessToken async {
    return _sharedPreference.getString(SharedPreferenceKeys.accessToken) ?? '';
  }

  Project? get project {
    final project = _sharedPreference.getString(SharedPreferenceKeys.project);
    if (project == null) {
      return null;
    }

    return Project.fromJson(json.decode(project));
  }

  UserData? get userData {
    final user = _sharedPreference.getString(SharedPreferenceKeys.userData);
    if (user == null) {
      return null;
    }

    return UserData.fromJson(json.decode(user));
  }

  Future<bool> saveIsFirsLaunchApp(bool isFirstLaunchApp) {
    return _sharedPreference.setBool(
      SharedPreferenceKeys.isFirstLaunchApp,
      isFirstLaunchApp,
    );
  }

  Future<bool> saveLanguageCode(String languageCode) {
    return _sharedPreference.setString(
      SharedPreferenceKeys.languageCode,
      languageCode,
    );
  }

  Future<bool> saveAppsVersionCodeSaved(int versionCodeSaved) async {
    return _sharedPreference.setInt(
      SharedPreferenceKeys.appsVersionCodeSaved,
      versionCodeSaved,
    );
  }

  String? get getAccessToken =>
      _sharedPreference.getString(SharedPreferenceKeys.accessToken);

  Future<void> saveAccessToken(String token) async {
    await _sharedPreference.setString(SharedPreferenceKeys.accessToken, token);
  }

  Future<void> saveProject(Project value) async {
    await _sharedPreference.setString(
      SharedPreferenceKeys.project,
      json.encode(value),
    );
  }

  Future<bool> saveUserData(UserData userData) {
    return _sharedPreference.setString(
      SharedPreferenceKeys.userData,
      json.encode(userData),
    );
  }

  Future<void> clearCurrentUserData() async {
    await Future.wait([
      _sharedPreference.remove(SharedPreferenceKeys.project),
      _sharedPreference.remove(SharedPreferenceKeys.userData),
      _sharedPreference.remove(SharedPreferenceKeys.accessToken),
      _sharedPreference.remove(SharedPreferenceKeys.fcmToken),
    ]);
  }
}
