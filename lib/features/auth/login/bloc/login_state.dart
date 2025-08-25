import 'package:farm/base/base.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState extends BaseBlocState with _$LoginState {
  const factory LoginState({
    @Default('') String fcmToken,
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isButtonVisible,
    @Default(false) bool isButtonLoginPressed,
    @Default(false) bool emailValid,
    @Default(false) bool loginInvalid,
    @Default(null) String? respError,
  }) = _LoginState;

  const LoginState._();
}
