import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_search_nav_bar_event.freezed.dart';

abstract class CattleSearchNavBarEvent extends BaseBlocEvent {
  const CattleSearchNavBarEvent();
}

@freezed
abstract class Initiated extends CattleSearchNavBarEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}
