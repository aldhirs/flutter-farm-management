import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item_add_event.freezed.dart';

abstract class MutationItemAddEvent extends BaseBlocEvent {
  const MutationItemAddEvent();
}

@freezed
abstract class Initiated extends MutationItemAddEvent with _$Initiated {
  const factory Initiated({
    required Mutation item,
    Cattle? cattle,
    String? rfid,
  }) = _Initiated;

  const Initiated._();
}

@freezed
abstract class IsSuccessChanged extends MutationItemAddEvent
    with _$IsSuccessChanged {
  const factory IsSuccessChanged({required bool value}) = _IsSuccessChanged;

  const IsSuccessChanged._();
}

@freezed
abstract class ClearError extends MutationItemAddEvent with _$ClearError {
  const factory ClearError() = _ClearError;
  const ClearError._();
}

@freezed
abstract class OnSubmit extends MutationItemAddEvent with _$OnSubmit {
  const factory OnSubmit() = _OnSubmit;

  const OnSubmit._();
}
