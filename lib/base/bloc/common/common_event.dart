import 'package:farm/base/base.dart';
import 'package:farm/base/exception/base/app_exception_wrapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_event.freezed.dart';

abstract class CommonEvent extends BaseBlocEvent {
  const CommonEvent();
}

@freezed
abstract class ExceptionEmitted extends CommonEvent with _$ExceptionEmitted {
  const factory ExceptionEmitted({
    required AppExceptionWrapper appExceptionWrapper,
  }) = _ExceptionEmitted;
  const ExceptionEmitted._();
}

@freezed
abstract class LoadingVisibilityEmitted extends CommonEvent
    with _$LoadingVisibilityEmitted {
  const factory LoadingVisibilityEmitted({required bool isLoading}) =
      _LoadingVisibilityEmitted;
  const LoadingVisibilityEmitted._();
}

@freezed
abstract class ForceLogoutButtonPressed extends CommonEvent
    with _$ForceLogoutButtonPressed {
  const factory ForceLogoutButtonPressed() = _ForceLogoutButtonPressed;
  const ForceLogoutButtonPressed._();
}
