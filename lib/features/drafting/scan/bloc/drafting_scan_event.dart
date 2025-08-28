import 'package:farm/base/base.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_scan_event.freezed.dart';

abstract class DraftingScanEvent extends BaseBlocEvent {
  const DraftingScanEvent();
}

@freezed
abstract class Initiated extends DraftingScanEvent with _$Initiated {
  const factory Initiated() = _Initiated;

  const Initiated._();
}

@freezed
abstract class AdapterState extends DraftingScanEvent with _$AdapterState {
  const factory AdapterState({required BluetoothAdapterState state}) =
      _AdapterState;

  const AdapterState._();
}

@freezed
abstract class Dispose extends DraftingScanEvent with _$Dispose {
  const factory Dispose() = _Dispose;

  const Dispose._();
}

@freezed
abstract class TurnOnBluetooth extends DraftingScanEvent
    with _$TurnOnBluetooth {
  const factory TurnOnBluetooth() = _TurnOnBluetooth;

  const TurnOnBluetooth._();
}

@freezed
abstract class TryConnection extends DraftingScanEvent with _$TryConnection {
  const factory TryConnection({
    required int index,
    required BluetoothDevice device,
  }) = _TryConnection;

  const TryConnection._();
}

@freezed
abstract class ClearError extends DraftingScanEvent with _$ClearError {
  const factory ClearError() = _ClearError;

  const ClearError._();
}

@freezed
abstract class StartScanning extends DraftingScanEvent with _$StartScanning {
  const factory StartScanning() = _StartScanning;

  const StartScanning._();
}

class AdapterStateChanged extends DraftingScanEvent {
  final BluetoothAdapterState adapter;
  const AdapterStateChanged(this.adapter);
}

class ScanResultsChanged extends DraftingScanEvent {
  final Set<BluetoothDevice> results;
  const ScanResultsChanged(this.results);
}

class ScanningChanged extends DraftingScanEvent {
  final bool scanning;
  const ScanningChanged(this.scanning);
}
