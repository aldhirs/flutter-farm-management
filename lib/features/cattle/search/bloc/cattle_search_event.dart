import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
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
  const factory Initiated({String? rfid, Cattle? cattle}) = _Initiated;
  const Initiated._();
}

@freezed
abstract class CheckCattle extends CattleSearchEvent with _$CheckCattle {
  const factory CheckCattle() = _CheckCattle;

  const CheckCattle._();
}

@freezed
abstract class OnRefresh extends CattleSearchEvent with _$OnRefresh {
  const factory OnRefresh() = _OnRefresh;

  const OnRefresh._();
}

@freezed
abstract class EarTagChanged extends CattleSearchEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}

@freezed
abstract class GetTreatments extends CattleSearchEvent with _$GetTreatments {
  const factory GetTreatments({required String id_cattle}) = _GetTreatments;

  const GetTreatments._();
}

@freezed
abstract class GetMedicals extends CattleSearchEvent with _$GetMedicals {
  const factory GetMedicals({required String id_cattle}) = _GetMedicals;

  const GetMedicals._();
}
