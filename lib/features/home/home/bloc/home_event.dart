import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

abstract class HomeEvent extends BaseBlocEvent {
  const HomeEvent();
}

@freezed
abstract class Initiated extends HomeEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}
