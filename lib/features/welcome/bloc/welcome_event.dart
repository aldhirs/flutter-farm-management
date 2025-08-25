import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'welcome_event.freezed.dart';

abstract class WelcomeEvent extends BaseBlocEvent {
  const WelcomeEvent();
}

@freezed
abstract class LoginPressed extends WelcomeEvent with _$LoginPressed {
  const factory LoginPressed() = _LoginPressed;
  const LoginPressed._();
}

@freezed
abstract class RegisterPressed extends WelcomeEvent with _$RegisterPressed {
  const factory RegisterPressed() = _RegisterPressed;
  const RegisterPressed._();
}

@freezed
abstract class Initiated extends WelcomeEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}
