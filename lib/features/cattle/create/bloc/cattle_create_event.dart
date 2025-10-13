import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/breed/breed.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:farm/domain/entities/station/station.dart';
import 'package:farm/domain/entities/supplier/supplier.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_create_event.freezed.dart';

abstract class CattleCreateEvent extends BaseBlocEvent {
  const CattleCreateEvent();
}

@freezed
abstract class Initiated extends CattleCreateEvent with _$Initiated {
  const factory Initiated({String? rfid}) = _Initiated;

  const Initiated._();
}

@freezed
abstract class IsSuccessChanged extends CattleCreateEvent
    with _$IsSuccessChanged {
  const factory IsSuccessChanged({required bool value}) = _IsSuccessChanged;

  const IsSuccessChanged._();
}

@freezed
abstract class ClearError extends CattleCreateEvent with _$ClearError {
  const factory ClearError() = _ClearError;
  const ClearError._();
}

@freezed
abstract class BreedChanged extends CattleCreateEvent with _$BreedChanged {
  const factory BreedChanged({required Breed value}) = _BreedChanged;

  const BreedChanged._();
}

@freezed
abstract class GenderChanged extends CattleCreateEvent with _$GenderChanged {
  const factory GenderChanged({required String value}) = _GenderChanged;

  const GenderChanged._();
}

@freezed
abstract class LevelChanged extends CattleCreateEvent with _$LevelChanged {
  const factory LevelChanged({required Level value}) = _LevelChanged;

  const LevelChanged._();
}

@freezed
abstract class BarnChanged extends CattleCreateEvent with _$BarnChanged {
  const factory BarnChanged({required Barn barn}) = _BarnChanged;

  const BarnChanged._();
}

@freezed
abstract class PenChanged extends CattleCreateEvent with _$PenChanged {
  const factory PenChanged({required Pen pen}) = _PenChanged;

  const PenChanged._();
}

@freezed
abstract class GetBarns extends CattleCreateEvent with _$GetBarns {
  const factory GetBarns({String? search}) = _GetBarns;

  const GetBarns._();
}

@freezed
abstract class GetBreeds extends CattleCreateEvent with _$GetBreeds {
  const factory GetBreeds() = _GetBreeds;

  const GetBreeds._();
}

@freezed
abstract class GetStations extends CattleCreateEvent with _$GetStations {
  const factory GetStations() = _GetStations;

  const GetStations._();
}

@freezed
abstract class GetLevels extends CattleCreateEvent with _$GetLevels {
  const factory GetLevels() = _GetLevels;

  const GetLevels._();
}

@freezed
abstract class GetSuppliers extends CattleCreateEvent with _$GetSuppliers {
  const factory GetSuppliers() = _GetSuppliers;

  const GetSuppliers._();
}

@freezed
abstract class GetReceptions extends CattleCreateEvent with _$GetReceptions {
  const factory GetReceptions({String? search}) = _GetReceptions;

  const GetReceptions._();
}

@freezed
abstract class GetPens extends CattleCreateEvent with _$GetPens {
  const factory GetPens({required String barnId}) = _GetPens;

  const GetPens._();
}

@freezed
abstract class OnSubmit extends CattleCreateEvent with _$OnSubmit {
  const factory OnSubmit() = _OnSubmit;

  const OnSubmit._();
}

@freezed
abstract class OnClear extends CattleCreateEvent with _$OnClear {
  const factory OnClear() = _OnClear;

  const OnClear._();
}

@freezed
abstract class EarTagChanged extends CattleCreateEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}

@freezed
abstract class SupplierChanged extends CattleCreateEvent
    with _$SupplierChanged {
  const factory SupplierChanged({required Supplier value}) = _SupplierChanged;

  const SupplierChanged._();
}

@freezed
abstract class StationChanged extends CattleCreateEvent with _$StationChanged {
  const factory StationChanged({required Station value}) = _StationChanged;

  const StationChanged._();
}

@freezed
abstract class ReceptionChanged extends CattleCreateEvent
    with _$ReceptionChanged {
  const factory ReceptionChanged({required Reception value}) =
      _ReceptionChanged;

  const ReceptionChanged._();
}
