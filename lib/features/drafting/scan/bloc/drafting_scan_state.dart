import 'package:farm/base/base.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_scan_state.freezed.dart';

@freezed
abstract class DraftingScanState extends BaseBlocState
    with _$DraftingScanState {
  const factory DraftingScanState({
    @Default(false) bool isConnected,
    @Default(false) bool isScanning,
    @Default(null) int? connectionIndex,
    @Default({}) Set<BluetoothDevice> scanResults,
    @Default(BluetoothAdapterState.unknown) BluetoothAdapterState adapterState,
    @Default('') String errorMessage,
    @Default(false) bool isError,
  }) = _DraftingScanState;

  const DraftingScanState._();
}
