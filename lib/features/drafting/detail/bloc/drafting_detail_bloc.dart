import 'dart:async';
import 'dart:convert';

import 'package:farm/base/base.dart';
import 'package:farm/features/drafting/detail/bloc/drafting_detail_event.dart';
import 'package:farm/features/drafting/detail/bloc/drafting_detail_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DraftingDetailBloc
    extends BaseBloc<DraftingDetailEvent, DraftingDetailState> {
  BluetoothConnection? _connection;
  StreamSubscription? _readSubscription;

  DraftingDetailBloc() : super(const DraftingDetailState()) {
    on<Initiated>(_initialized, transformer: log());
    on<StartScanning>(_startScanning, transformer: log());
    on<BottomsheetDismiss>((event, emit) {
      emit(state.copyWith(isShowBottomsheet: false, rfid: '', loading: false));
    }, transformer: log());
    on<RFIDChanged>((event, emit) {
      emit(
        state.copyWith(
          rfid: event.rfid,
          loading: false,
          isShowBottomsheet: true,
        ),
      );
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<DraftingDetailState> emit,
  ) async {
    _connection = event.connection;
    try {
      _readSubscription = _connection?.input?.listen((event) {
        final rfid = utf8.decode(event).replaceAll(RegExp(r'\s+'), '');
        add(RFIDChanged(rfid: rfid));
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _startScanning(
    StartScanning event,
    Emitter<DraftingDetailState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    // bypass-debug
    Future.delayed(const Duration(seconds: 1), () {
      add(RFIDChanged(rfid: '98204537512065671'));
    });
  }

  @override
  Future<void> close() async {
    _connection?.dispose();
    _readSubscription?.cancel();
    super.close();
  }
}
