import 'package:farm/base/base.dart';
import 'package:farm/config/app_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState extends BaseBlocState with _$AppState {
  const factory AppState({
    @Default(false) bool isLoggedIn,
    @Default(false) bool isDarkTheme,
    @Default('') String fcmToken,
  }) = _AppState;
  const AppState._();
}
