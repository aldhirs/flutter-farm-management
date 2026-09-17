import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_event.freezed.dart';

abstract class ChangePasswordEvent extends BaseBlocEvent {
  const ChangePasswordEvent();
}

@freezed
abstract class OldPasswordChanged extends ChangePasswordEvent
    with _$OldPasswordChanged {
  const factory OldPasswordChanged({required String value}) =
      _OldPasswordChanged;
  const OldPasswordChanged._();
}

@freezed
abstract class NewPasswordChanged extends ChangePasswordEvent
    with _$NewPasswordChanged {
  const factory NewPasswordChanged({required String value}) =
      _NewPasswordChanged;
  const NewPasswordChanged._();
}

@freezed
abstract class ConfirmPasswordChanged extends ChangePasswordEvent
    with _$ConfirmPasswordChanged {
  const factory ConfirmPasswordChanged({required String value}) =
      _ConfirmPasswordChanged;
  const ConfirmPasswordChanged._();
}

@freezed
abstract class SubmitPressed extends ChangePasswordEvent with _$SubmitPressed {
  const factory SubmitPressed() = _SubmitPressed;
  const SubmitPressed._();
}
