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

@freezed
abstract class CheckCattleEarTag extends HomeEvent with _$CheckCattleEarTag {
  const factory CheckCattleEarTag({required int destination}) =
      _CheckCattleEarTag;

  const CheckCattleEarTag._();
}

@freezed
abstract class EarTagChanged extends HomeEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}

@freezed
abstract class ClearData extends HomeEvent with _$ClearData {
  const factory ClearData() = _ClearData;

  const ClearData._();
}
