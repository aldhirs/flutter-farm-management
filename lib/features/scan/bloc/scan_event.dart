import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_event.freezed.dart';

abstract class ScanEvent extends BaseBlocEvent {
  const ScanEvent();
}

@freezed
abstract class Initiated extends ScanEvent with _$Initiated {
  const factory Initiated({required Sales sales, required String route}) =
      _Initiated;

  const Initiated._();
}

@freezed
abstract class AdapterState extends ScanEvent with _$AdapterState {
  const factory AdapterState({required BluetoothAdapterState state}) =
      _AdapterState;

  const AdapterState._();
}

@freezed
abstract class Dispose extends ScanEvent with _$Dispose {
  const factory Dispose() = _Dispose;

  const Dispose._();
}

@freezed
abstract class TurnOnBluetooth extends ScanEvent with _$TurnOnBluetooth {
  const factory TurnOnBluetooth() = _TurnOnBluetooth;

  const TurnOnBluetooth._();
}

@freezed
abstract class TryConnection extends ScanEvent with _$TryConnection {
  const factory TryConnection({
    required int index,
    required BluetoothDevice device,
  }) = _TryConnection;

  const TryConnection._();
}

@freezed
abstract class ClearError extends ScanEvent with _$ClearError {
  const factory ClearError() = _ClearError;

  const ClearError._();
}

@freezed
abstract class StartScanning extends ScanEvent with _$StartScanning {
  const factory StartScanning() = _StartScanning;

  const StartScanning._();
}

class AdapterStateChanged extends ScanEvent {
  final BluetoothAdapterState adapter;
  const AdapterStateChanged(this.adapter);
}

class ScanResultsChanged extends ScanEvent {
  final Set<BluetoothDevice> results;
  const ScanResultsChanged(this.results);
}

class ScanningChanged extends ScanEvent {
  final bool scanning;
  const ScanningChanged(this.scanning);
}
