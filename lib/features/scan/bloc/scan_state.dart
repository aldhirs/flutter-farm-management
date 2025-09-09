import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_state.freezed.dart';

@freezed
abstract class ScanState extends BaseBlocState with _$ScanState {
  const factory ScanState({
    @Default(false) bool isConnected,
    @Default(false) bool isScanning,
    @Default(null) int? connectionIndex,
    @Default({}) Set<BluetoothDevice> scanResults,
    @Default(BluetoothAdapterState.unknown) BluetoothAdapterState adapterState,
    @Default('') String errorMessage,
    @Default(false) bool isError,
    @Default(Sales()) Sales sales,
    @Default('') String route,
  }) = _ScanState;

  const ScanState._();
}
