import 'package:farm/base/base.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_detail_event.freezed.dart';

abstract class DraftingDetailEvent extends BaseBlocEvent {
  const DraftingDetailEvent();
}

@freezed
abstract class Initiated extends DraftingDetailEvent with _$Initiated {
  const factory Initiated({required BluetoothConnection? connection}) =
      _Initiated;

  const Initiated._();
}

@freezed
abstract class RFIDChanged extends DraftingDetailEvent with _$RFIDChanged {
  const factory RFIDChanged({required String rfid}) = _RFIDChanged;

  const RFIDChanged._();
}

@freezed
abstract class StartScanning extends DraftingDetailEvent with _$StartScanning {
  const factory StartScanning() = _StartScanning;

  const StartScanning._();
}

@freezed
abstract class BottomsheetDismiss extends DraftingDetailEvent
    with _$BottomsheetDismiss {
  const factory BottomsheetDismiss() = _BottomsheetDismiss;

  const BottomsheetDismiss._();
}
