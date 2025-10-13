import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/medical/medical_type.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/treatment/treatment_type.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_form_event.freezed.dart';

abstract class DraftingFormEvent extends BaseBlocEvent {
  const DraftingFormEvent();
}

@freezed
abstract class Initiated extends DraftingFormEvent with _$Initiated {
  const factory Initiated({String? rfid, Cattle? cattle}) = _Initiated;

  const Initiated._();
}

@freezed
abstract class GetCattle extends DraftingFormEvent with _$GetCattle {
  const factory GetCattle({required Cattle cattle}) = _GetCattle;

  const GetCattle._();
}

@freezed
abstract class IdentityInit extends DraftingFormEvent with _$IdentityInit {
  const factory IdentityInit() = _IdentityInit;

  const IdentityInit._();
}

@freezed
abstract class TreatmentInit extends DraftingFormEvent with _$TreatmentInit {
  const factory TreatmentInit() = _TreatmentInit;

  const TreatmentInit._();
}

@freezed
abstract class MedicalInit extends DraftingFormEvent with _$MedicalInit {
  const factory MedicalInit() = _MedicalInit;

  const MedicalInit._();
}

@freezed
abstract class IdentitySuccessChanged extends DraftingFormEvent
    with _$IdentitySuccessChanged {
  const factory IdentitySuccessChanged({required bool value}) =
      _IdentitySuccessChanged;

  const IdentitySuccessChanged._();
}

@freezed
abstract class GrowthSuccessChanged extends DraftingFormEvent
    with _$GrowthSuccessChanged {
  const factory GrowthSuccessChanged({required bool value}) =
      _GrowthSuccessChanged;

  const GrowthSuccessChanged._();
}

@freezed
abstract class TreatmentSuccessChanged extends DraftingFormEvent
    with _$TreatmentSuccessChanged {
  const factory TreatmentSuccessChanged({required bool value}) =
      _TreatmentSuccessChanged;

  const TreatmentSuccessChanged._();
}

@freezed
abstract class MedicSuccessChanged extends DraftingFormEvent
    with _$MedicSuccessChanged {
  const factory MedicSuccessChanged({required bool value}) =
      _MedicSuccessChanged;

  const MedicSuccessChanged._();
}

@freezed
abstract class ClearErrorIdentity extends DraftingFormEvent
    with _$ClearErrorIdentity {
  const factory ClearErrorIdentity() = _ClearErrorIdentity;
  const ClearErrorIdentity._();
}

@freezed
abstract class GetBarns extends DraftingFormEvent with _$GetBarns {
  const factory GetBarns({String? search}) = _GetBarns;

  const GetBarns._();
}

@freezed
abstract class BarnChanged extends DraftingFormEvent with _$BarnChanged {
  const factory BarnChanged({required Barn barn}) = _BarnChanged;

  const BarnChanged._();
}

@freezed
abstract class PenChanged extends DraftingFormEvent with _$PenChanged {
  const factory PenChanged({required Pen pen}) = _PenChanged;

  const PenChanged._();
}

@freezed
abstract class EarTagChanged extends DraftingFormEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}

@freezed
abstract class LevelChanged extends DraftingFormEvent with _$LevelChanged {
  const factory LevelChanged({required Level value}) = _LevelChanged;

  const LevelChanged._();
}

@freezed
abstract class TreatmentTypeChanged extends DraftingFormEvent
    with _$TreatmentTypeChanged {
  const factory TreatmentTypeChanged({required List<TreatmentType> values}) =
      _TreatmentTypeChanged;

  const TreatmentTypeChanged._();
}

@freezed
abstract class MedicalTypeChanged extends DraftingFormEvent
    with _$MedicalTypeChanged {
  const factory MedicalTypeChanged({required MedicalType value}) =
      _MedicalTypeChanged;

  const MedicalTypeChanged._();
}

@freezed
abstract class GetPens extends DraftingFormEvent with _$GetPens {
  const factory GetPens({required String barnId}) = _GetPens;

  const GetPens._();
}

@freezed
abstract class OnSubmitIdentity extends DraftingFormEvent
    with _$OnSubmitIdentity {
  const factory OnSubmitIdentity() = _OnSubmitIdentity;

  const OnSubmitIdentity._();
}

@freezed
abstract class OnSubmitGrowth extends DraftingFormEvent with _$OnSubmitGrowth {
  const factory OnSubmitGrowth() = _OnSubmitGrowth;

  const OnSubmitGrowth._();
}

@freezed
abstract class OnSubmitTreatment extends DraftingFormEvent
    with _$OnSubmitTreatment {
  const factory OnSubmitTreatment() = _OnSubmitTreatment;

  const OnSubmitTreatment._();
}

@freezed
abstract class OnSubmitMedical extends DraftingFormEvent
    with _$OnSubmitMedical {
  const factory OnSubmitMedical() = _OnSubmitMedical;

  const OnSubmitMedical._();
}

@freezed
abstract class WeightChanged extends DraftingFormEvent with _$WeightChanged {
  const factory WeightChanged({required String value}) = _WeightChanged;

  const WeightChanged._();
}

@freezed
abstract class TreatmentDateChanged extends DraftingFormEvent
    with _$TreatmentDateChanged {
  const factory TreatmentDateChanged({DateTime? value}) = _TreatmentDateChanged;

  const TreatmentDateChanged._();
}

@freezed
abstract class TreatmentNoteChanged extends DraftingFormEvent
    with _$TreatmentNoteChanged {
  const factory TreatmentNoteChanged({required String value}) =
      _TreatmentNoteChanged;

  const TreatmentNoteChanged._();
}

@freezed
abstract class InfectionChanged extends DraftingFormEvent
    with _$InfectionChanged {
  const factory InfectionChanged({required bool value}) = _InfectionChanged;

  const InfectionChanged._();
}

@freezed
abstract class MedicalNoteChanged extends DraftingFormEvent
    with _$MedicalNoteChanged {
  const factory MedicalNoteChanged({required String value}) =
      _MedicalNoteChanged;

  const MedicalNoteChanged._();
}

@freezed
abstract class MedicalStatusChanged extends DraftingFormEvent
    with _$MedicalStatusChanged {
  const factory MedicalStatusChanged({required String value}) =
      _MedicalStatusChanged;

  const MedicalStatusChanged._();
}

@freezed
abstract class GenderChanged extends DraftingFormEvent with _$GenderChanged {
  const factory GenderChanged({required String value}) = _GenderChanged;

  const GenderChanged._();
}

class MedicalFileAdded extends DraftingFormEvent {
  final String filePath;
  const MedicalFileAdded({required this.filePath});
}

class MedicalFileRemoved extends DraftingFormEvent {
  const MedicalFileRemoved();
}
