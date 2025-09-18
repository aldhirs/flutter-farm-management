import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_search_event.freezed.dart';

abstract class CattleSearchEvent extends BaseBlocEvent {
  const CattleSearchEvent();
}

@freezed
abstract class Initiated extends CattleSearchEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}

@freezed
abstract class CheckCattleEarTag extends CattleSearchEvent
    with _$CheckCattleEarTag {
  const factory CheckCattleEarTag() = _CheckCattleEarTag;

  const CheckCattleEarTag._();
}

@freezed
abstract class EarTagChanged extends CattleSearchEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}
