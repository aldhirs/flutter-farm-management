import 'package:farm/base/base.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.freezed.dart';

abstract class LoginEvent extends BaseBlocEvent {
  const LoginEvent();
}

@freezed
abstract class Initiated extends LoginEvent with _$Initiated {
  const factory Initiated({String? messageChangePassword, String? fcmToken}) =
      _Initiated;

  const Initiated._();
}

@freezed
abstract class OnLoginPressed extends LoginEvent with _$OnLoginPressed {
  const factory OnLoginPressed() = _OnLoginPressed;

  const OnLoginPressed._();
}

@freezed
abstract class InitForgotPassword extends LoginEvent with _$InitForgotPassword {
  const factory InitForgotPassword({
    required String title,
    required List<InlineSpan> subtitle,
    required String buttonTitle,
  }) = _InitForgotPassword;

  const InitForgotPassword._();
}

@freezed
abstract class ForgotPasswordPressed extends LoginEvent
    with _$ForgotPasswordPressed {
  const factory ForgotPasswordPressed() = _ForgotPasswordPressed;

  const ForgotPasswordPressed._();
}

@freezed
abstract class OnInputEmailChanged extends LoginEvent
    with _$OnInputEmailChanged {
  const factory OnInputEmailChanged({required String email}) =
      _OnInputEmailChanged;

  const OnInputEmailChanged._();
}

@freezed
abstract class OnInputPasswordChanged extends LoginEvent
    with _$OnInputPasswordChanged {
  const factory OnInputPasswordChanged({required String password}) =
      _OnInputPasswordChanged;

  const OnInputPasswordChanged._();
}

@freezed
abstract class ClearError extends LoginEvent with _$ClearError {
  const factory ClearError() = _ClearError;

  const ClearError._();
}
