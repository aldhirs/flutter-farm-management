import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

/// define custom themes here
final lightTheme = ThemeData(
  brightness: Brightness.light,
  splashColor: Colors.transparent,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.defaultAppColor.text100,
    selectionColor: AppColors.defaultAppColor.text300,
    selectionHandleColor: AppColors.defaultAppColor.text300,
  ),
)..addAppColor(AppThemeType.light, AppColors.defaultAppColor);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  splashColor: Colors.transparent,
)..addAppColor(AppThemeType.dark, AppColors.darkThemeColor);

enum AppThemeType { light, dark }

extension ThemeDataExtensions on ThemeData {
  static final Map<AppThemeType, AppColors> _appColorMap = {};

  void addAppColor(AppThemeType type, AppColors appColor) {
    _appColorMap[type] = appColor;
  }

  AppColors get appColor {
    return _appColorMap[AppThemeSetting.currentAppThemeType] ??
        AppColors.defaultAppColor;
  }
}

class AppThemeSetting {
  const AppThemeSetting._();
  static AppThemeType currentAppThemeType = AppThemeType.light;
}
