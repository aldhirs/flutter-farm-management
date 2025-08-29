import 'package:farm/base/base.dart';
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
