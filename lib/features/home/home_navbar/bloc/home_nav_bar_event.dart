import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_nav_bar_event.freezed.dart';

abstract class HomeNavBarEvent extends BaseBlocEvent {
  const HomeNavBarEvent();
}

@freezed
abstract class Initiated extends HomeNavBarEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}
