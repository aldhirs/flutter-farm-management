import 'package:farm/base/base.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_preview_event.freezed.dart';

abstract class SalesItemPreviewEvent extends BaseBlocEvent {
  const SalesItemPreviewEvent();
}

@freezed
abstract class Initiated extends SalesItemPreviewEvent with _$Initiated {
  const factory Initiated({required BluetoothConnection? connection}) =
      _Initiated;

  const Initiated._();
}

@freezed
abstract class RFIDChanged extends SalesItemPreviewEvent with _$RFIDChanged {
  const factory RFIDChanged({required String rfid}) = _RFIDChanged;

  const RFIDChanged._();
}

@freezed
abstract class StartScanning extends SalesItemPreviewEvent
    with _$StartScanning {
  const factory StartScanning() = _StartScanning;

  const StartScanning._();
}

@freezed
abstract class BottomsheetDismiss extends SalesItemPreviewEvent
    with _$BottomsheetDismiss {
  const factory BottomsheetDismiss() = _BottomsheetDismiss;

  const BottomsheetDismiss._();
}
