import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_add_event.freezed.dart';

abstract class SalesItemAddEvent extends BaseBlocEvent {
  const SalesItemAddEvent();
}

@freezed
abstract class Initiated extends SalesItemAddEvent with _$Initiated {
  const factory Initiated({required Sales sale, Cattle? cattle, String? rfid}) =
      _Initiated;

  const Initiated._();
}

@freezed
abstract class IsSuccessChanged extends SalesItemAddEvent
    with _$IsSuccessChanged {
  const factory IsSuccessChanged({required bool value}) = _IsSuccessChanged;

  const IsSuccessChanged._();
}

@freezed
abstract class ClearError extends SalesItemAddEvent with _$ClearError {
  const factory ClearError() = _ClearError;
  const ClearError._();
}

@freezed
abstract class BarnChanged extends SalesItemAddEvent with _$BarnChanged {
  const factory BarnChanged({required Barn barn}) = _BarnChanged;

  const BarnChanged._();
}

@freezed
abstract class PenChanged extends SalesItemAddEvent with _$PenChanged {
  const factory PenChanged({required Pen pen}) = _PenChanged;

  const PenChanged._();
}

@freezed
abstract class GetBarns extends SalesItemAddEvent with _$GetBarns {
  const factory GetBarns() = _GetBarns;

  const GetBarns._();
}

@freezed
abstract class GetPens extends SalesItemAddEvent with _$GetPens {
  const factory GetPens({required String barnId}) = _GetPens;

  const GetPens._();
}

@freezed
abstract class OnSubmit extends SalesItemAddEvent with _$OnSubmit {
  const factory OnSubmit() = _OnSubmit;

  const OnSubmit._();
}

@freezed
abstract class WeightChanged extends SalesItemAddEvent with _$WeightChanged {
  const factory WeightChanged({required String value}) = _WeightChanged;

  const WeightChanged._();
}
