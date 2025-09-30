import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/sales/sales_item_add_request.dart';
import 'package:farm/domain/usecases/barns_use_case.dart';
import 'package:farm/domain/usecases/cattle_by_rfid_use_case.dart';
import 'package:farm/domain/usecases/get_user_data_use_case.dart';
import 'package:farm/domain/usecases/pens_use_case.dart';
import 'package:farm/domain/usecases/sales_item_add_use_case.dart';
import 'package:farm/features/sales/add/model/list_item.dart';
import 'package:farm/features/sales/add/bloc/sales_item_add_event.dart';
import 'package:farm/features/sales/add/bloc/sales_item_add_state.dart';
import 'package:farm/helper/run_catching/result.dart';
import 'package:farm/helper/run_catching/run_catching.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SalesItemAddBloc extends BaseBloc<SalesItemAddEvent, SalesItemAddState> {
  final CattleByRFIDUseCase _cattleUseCase;
  final GetUserDataUseCase _userDataUseCase;
  final BarnsUseCase _barnsUseCase;
  final PensUseCase _pensUseCase;
  final SalesItemAddUseCase _salesItemAddUseCase;

  SalesItemAddBloc(
    this._cattleUseCase,
    this._userDataUseCase,
    this._barnsUseCase,
    this._pensUseCase,
    this._salesItemAddUseCase,
  ) : super(const SalesItemAddState()) {
    on<Initiated>(_initialized, transformer: log());
    on<OnSubmit>(_onSubmit, transformer: log());
    on<GetBarns>(_barnsApi, transformer: log());
    on<GetPens>(_getPensApi, transformer: log());
    on<IsSuccessChanged>((event, emit) {
      emit(state.copyWith(isSuccess: event.value));
    }, transformer: log());
    on<BarnChanged>((event, emit) {
      emit(state.copyWith(selectedBarn: event.barn, selectedPen: null));
      add(GetPens(barnId: event.barn.id));
    }, transformer: log());
    on<PenChanged>((event, emit) {
      emit(state.copyWith(selectedPen: event.pen));
    }, transformer: log());
    on<WeightChanged>((event, emit) {
      emit(state.copyWith(weight: event.value));
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<SalesItemAddState> emit,
  ) async {
    final cattle = event.cattle ?? const Cattle();
    final items = _getCattleItems(cattle);

    emit(
      state.copyWith(
        sale: event.sale,
        cattle: cattle,
        listItems: items,
        rfid: event.rfid.orEmpty(),
      ),
    );
    if (event.rfid?.isNotEmpty == true) {
      await _cattleApi(event.rfid.orEmpty(), emit);
    }

    if (cattle.id != "") {
      add(const GetBarns());
    }

    // user data
    final user = switch (runCatching(
      action: () => _userDataUseCase.execute(const GetUserDataInput()),
    )) {
      ResultSuccess(:final data) => data,
      _ => const UserData(),
    };
    emit(state.copyWith(userData: user));
  }

  Future<void> _onSubmit(
    OnSubmit event,
    Emitter<SalesItemAddState> emit,
  ) async {
    emit(state.copyWith(errorMessage: ''));
    if (state.selectedBarn == null ||
        state.selectedPen == null ||
        state.weight == "0" ||
        state.weight == null) {
      emit(
        state.copyWith(
          errorMessage:
              'Harap mengisi kandang, pen, bobot sapi terlebih dahulu.',
        ),
      );
      return;
    }
    await _onSubmitApi(emit);
  }

  @override
  Future<void> close() async {
    // _connection?.dispose();
    // _readSubscription?.cancel();
    super.close();
  }

  Future<void> _cattleApi(String rfid, Emitter<SalesItemAddState> emit) {
    return runBlocCatching(
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true));
        final response = await _cattleUseCase.execute(
          CattleRequest(
            rfid: rfid,
            id_project: appBloc.state.selectedProject?.id ?? '0',
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            final items = _getCattleItems(data);
            add(const GetBarns());
            emit(state.copyWith(cattle: data, listItems: items));
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

  Future<void> _barnsApi(GetBarns event, Emitter<SalesItemAddState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _barnsUseCase.execute(
          BarnRequest(
            projectId: appBloc.state.selectedProject!.id,
            category: "Drafting",
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(barns: data, errorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {},
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _getPensApi(GetPens event, Emitter<SalesItemAddState> emit) {
    return runBlocCatching(
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _pensUseCase.execute(
          PenRequest(
            barnId: event.barnId,
            projectId: appBloc.state.selectedProject!.id,
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(pens: data, errorMessage: ''));
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

  Future<void> _onSubmitApi(Emitter<SalesItemAddState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, isSuccess: false));
        final payload = SalesItemAddRequest(
          id_sale: state.sale.id,
          id_cattle: state.cattle?.id ?? '',
          id_pen: state.selectedPen?.id ?? '',
          weight: int.tryParse(state.weight ?? '') ?? 0,
        );
        final response = await _salesItemAddUseCase.execute(payload);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(isSuccess: true, errorMessage: ''));
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

  bool _isProjectChosen(Emitter<SalesItemAddState> emit) {
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

  List<ListItem> _getCattleItems(Cattle data) {
    final items = [
      ListItem(name: 'ID', description: data.id),
      ListItem(name: 'RFID', description: data.rfid_tag),
      ListItem(name: 'Kandang', description: data.pen?.name_barn ?? '-'),
      ListItem(name: 'Pen', description: data.pen?.name ?? '-'),
      ListItem(name: 'Ear Tag', description: data.ear_tag),
      ListItem(
        name: 'Bobot',
        description: '${data.actual_weight.toString()} Kg',
      ),
      ListItem(name: 'Ras', description: data.id_breed),
      ListItem(name: 'Jenis Kelamin', description: data.genderLabel()),
      ListItem(name: 'Status', description: data.statusLabel()),
    ];
    return items;
  }
}
