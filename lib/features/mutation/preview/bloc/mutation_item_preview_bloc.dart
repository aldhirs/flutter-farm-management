import 'dart:async';
import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/mutation/mutation_item_add_request.dart';
import 'package:farm/domain/usecases/cattle_by_rfid_use_case.dart';
import 'package:farm/domain/usecases/mutation_item_add_use_case.dart';
import 'package:farm/features/mutation/preview/bloc/mutation_item_preview_event.dart';
import 'package:farm/features/mutation/preview/bloc/mutation_item_preview_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MutationItemPreviewBloc
    extends BaseBloc<MutationItemPreviewEvent, MutationItemPreviewState> {
  final MutationItemAddUseCase _mutationItemAddUseCase;
  final CattleByRFIDUseCase _cattleByRFIDUseCase;
  BluetoothConnection? _connection;
  StreamSubscription? _readSubscription;

  MutationItemPreviewBloc(
    this._mutationItemAddUseCase,
    this._cattleByRFIDUseCase,
  ) : super(const MutationItemPreviewState()) {
    on<Initiated>(_initialized, transformer: log());
    on<OnSubmitAdd>(_onSubmitAddApi, transformer: log());
    on<CheckCattle>(_getCattleApi, transformer: log());
    on<StartScanning>(_startScanning, transformer: log());
    on<BottomsheetDismiss>((event, emit) {
      emit(state.copyWith(rfid: '', loading: false));
    }, transformer: log());
    on<RFIDChanged>((event, emit) {
      emit(state.copyWith(rfid: event.rfid, loading: false));
    }, transformer: log());
    on<OnClear>((event, emit) {
      emit(
        state.copyWith(
          rfid: '',
          loading: false,
          isSuccessAdd: false,
          cattle: null,
          errorMessage: "",
        ),
      );
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<MutationItemPreviewState> emit,
  ) async {
    emit(state.copyWith(mutation: event.mutation));
    _connection = event.connection;
    try {
      _readSubscription = _connection?.input?.listen((event) {
        final rfid = utf8.decode(event).trim().replaceAll('\\', '');
        add(RFIDChanged(rfid: rfid));
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _startScanning(
    StartScanning event,
    Emitter<MutationItemPreviewState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    // bypass-debug
    Future.delayed(const Duration(seconds: 1), () {
      add(RFIDChanged(rfid: "1003"));
    });
  }

  @override
  Future<void> close() async {
    _connection?.dispose();
    _readSubscription?.cancel();
    super.close();
  }

  Future<void> _getCattleApi(
    CheckCattle event,
    Emitter<MutationItemPreviewState> emit,
  ) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, cattle: null, rfid: event.rfid));
        final req = CattleRequest(
          id_project: appBloc.state.selectedProject?.id ?? '',
          rfid: event.rfid,
        );
        final response = await _cattleByRFIDUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(cattle: data, errorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  bool _isProjectChosen(Emitter<MutationItemPreviewState> emit) {
    if (appBloc.state.selectedProject == null) {
      emit(
        state.copyWith(
          errorMessage:
              'Anda harus memilih feedlot terlebih dahulu pada halaman beranda.',
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _onSubmitAddApi(
    OnSubmitAdd event,
    Emitter<MutationItemPreviewState> emit,
  ) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, isSuccessAdd: false));
        final payload = MutationItemAddRequest(
          id_mutation: state.mutation.id,
          id_cattles: [(state.cattle?.id).orEmpty()],
        );
        final response = await _mutationItemAddUseCase.execute(payload);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                isSuccessAdd: true,
                errorMessage: '',
                rfid: '',
                cattle: null,
              ),
            );
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: true,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }
}
