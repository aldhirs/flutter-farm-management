import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_event.freezed.dart';

abstract class AppEvent extends BaseBlocEvent {
  const AppEvent();
}

@freezed
abstract class IsLoggedInStatusChanged extends AppEvent
    with _$IsLoggedInStatusChanged {
  const factory IsLoggedInStatusChanged({required bool isLoggedIn}) =
      _IsLoggedInStatusChanged;
  const IsLoggedInStatusChanged._();
}

@freezed
abstract class AppThemeChanged extends AppEvent with _$AppThemeChanged {
  const factory AppThemeChanged({required bool isDarkTheme}) = _AppThemeChanged;
  const AppThemeChanged._();
}

@freezed
abstract class OnUpdateFcmToken extends AppEvent with _$OnUpdateFcmToken {
  const factory OnUpdateFcmToken({required String token}) = _OnUpdateFcmToken;
  const OnUpdateFcmToken._();
}

@freezed
abstract class AppInitiated extends AppEvent with _$AppInitiated {
  const factory AppInitiated() = _AppInitiated;
  const AppInitiated._();
}
