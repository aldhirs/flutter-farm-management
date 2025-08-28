import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_event.freezed.dart';

abstract class AccountEvent extends BaseBlocEvent {
  const AccountEvent();
}

@freezed
abstract class Initiated extends AccountEvent with _$Initiated {
  const factory Initiated(String? packageName) = _Initiated;
  const Initiated._();
}

@freezed
abstract class ClearPopupConfirmation extends AccountEvent
    with _$ClearPopupConfirmation {
  const factory ClearPopupConfirmation() = _ClearPopupConfirmation;
  const ClearPopupConfirmation._();
}

@freezed
abstract class LogoutPressed extends AccountEvent with _$LogoutPressed {
  const factory LogoutPressed() = _LogoutPressed;
  const LogoutPressed._();
}

@freezed
abstract class OnNotificationCount extends AccountEvent
    with _$OnNotificationCount {
  const factory OnNotificationCount() = _OnNotificationCount;
  const OnNotificationCount._();
}

@freezed
abstract class InboxPressed extends AccountEvent with _$InboxPressed {
  const factory InboxPressed() = _InboxPressed;
  const InboxPressed._();
}

@freezed
abstract class OnLogoutConfirmPressed extends AccountEvent
    with _$OnLogoutConfirmPressed {
  const factory OnLogoutConfirmPressed() = _OnLogoutConfirmPressed;
  const OnLogoutConfirmPressed._();
}
