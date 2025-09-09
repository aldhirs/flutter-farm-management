import 'dart:async';

import 'package:farm/base/base.dart';
import 'package:farm/features/scan/bloc/scan_event.dart';
import 'package:farm/features/scan/bloc/scan_state.dart';
import 'package:farm/features/scan/scan_page.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ScanBloc extends BaseBloc<ScanEvent, ScanState> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();
  StreamSubscription? _adapterStateSubscription;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _scanningStateSubscription;

  ScanBloc() : super(const ScanState()) {
    on<Initiated>(_initialized, transformer: log());
    on<TurnOnBluetooth>(_turnOnBluetooth, transformer: log());
    on<StartScanning>(_startScanning, transformer: log());
    on<TryConnection>(_tryConnection, transformer: log());
    on<ClearError>(_clearError, transformer: log());
    on<Dispose>(_dispose, transformer: log());
    on<AdapterStateChanged>((event, emit) {
      emit(state.copyWith(adapterState: event.adapter));
    }, transformer: log());
    on<ScanResultsChanged>((event, emit) {
      emit(state.copyWith(scanResults: event.results));
    }, transformer: log());
    on<ScanningChanged>((event, emit) {
      emit(state.copyWith(isScanning: event.scanning));
    }, transformer: log());
  }

  Future<void> _initialized(Initiated event, Emitter<ScanState> emit) async {
    emit(state.copyWith(route: event.route, sales: event.sales));
    var adapterState = BluetoothAdapterState.unknown;
    final Set<BluetoothDevice> devices = {};
    try {
      adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
      add(AdapterStateChanged(adapterState));
      _adapterStateSubscription = _flutterBlueClassicPlugin.adapterState.listen(
        (current) {
          add(AdapterStateChanged(current));
        },
      );

      _scanSubscription = _flutterBlueClassicPlugin.scanResults.listen((
        device,
      ) {
        devices.add(device);
        add(ScanResultsChanged(devices));
      });
      _scanningStateSubscription = _flutterBlueClassicPlugin.isScanning.listen((
        isScanning,
      ) {
        add(ScanningChanged(isScanning));
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  Future<void> close() async {
    //cancel streams
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();

    super.close();
  }

  Future<void> _turnOnBluetooth(
    TurnOnBluetooth event,
    Emitter<ScanState> emit,
  ) async {
    _flutterBlueClassicPlugin.turnOn();
  }

  Future<void> _dispose(Dispose event, Emitter<ScanState> emit) async {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
  }

  Future<void> _tryConnection(
    TryConnection event,
    Emitter<ScanState> emit,
  ) async {
    BluetoothConnection? connection;
    emit(state.copyWith(connectionIndex: event.index));
    try {
      connection = await _flutterBlueClassicPlugin.connect(
        event.device.address,
      );
      if (connection != null && connection.isConnected) {
        emit(state.copyWith(connectionIndex: null));
        switch (state..route) {
          case DEST_DRAFTING_DETAIL:
            navigator.push(AppRouteInfo.draftingDetail(connection: connection));
            break;
          case DEST_SALES_ITEM:
            navigator.push(AppRouteInfo.salesItemForm(item: state.sales));
            break;
          default:
            navigator.push(AppRouteInfo.draftingDetail(connection: connection));
            break;
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          connectionIndex: null,
          isError: true,
          errorMessage: 'Error connecting to device',
        ),
      );
      if (kDebugMode) print(e);
      connection?.dispose();
    }
  }

  Future<void> _clearError(ClearError event, Emitter<ScanState> emit) async {
    emit(state.copyWith(isError: false, errorMessage: ''));
  }

  Future<void> _startScanning(
    StartScanning event,
    Emitter<ScanState> emit,
  ) async {
    if (state.isScanning) {
      _flutterBlueClassicPlugin.stopScan();
    } else {
      add(const ScanResultsChanged({}));
      _flutterBlueClassicPlugin.startScan();
    }
  }
}
