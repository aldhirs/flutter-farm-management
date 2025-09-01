import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_form_event.freezed.dart';

abstract class DraftingFormEvent extends BaseBlocEvent {
  const DraftingFormEvent();
}

@freezed
abstract class Initiated extends DraftingFormEvent with _$Initiated {
  const factory Initiated({required String rfid}) = _Initiated;

  const Initiated._();
}

@freezed
abstract class IdentityInit extends DraftingFormEvent with _$IdentityInit {
  const factory IdentityInit() = _IdentityInit;

  const IdentityInit._();
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
