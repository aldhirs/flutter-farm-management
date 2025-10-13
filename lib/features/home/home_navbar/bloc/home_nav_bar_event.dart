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

@freezed
abstract class CheckCattleEarTag extends HomeNavBarEvent
    with _$CheckCattleEarTag {
  const factory CheckCattleEarTag({required int destination}) =
      _CheckCattleEarTag;

  const CheckCattleEarTag._();
}

@freezed
abstract class EarTagChanged extends HomeNavBarEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}

@freezed
abstract class ClearData extends HomeNavBarEvent with _$ClearData {
  const factory ClearData() = _ClearData;

  const ClearData._();
}
