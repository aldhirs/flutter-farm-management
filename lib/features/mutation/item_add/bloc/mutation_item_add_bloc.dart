import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/mutation/mutation_item_add_request.dart';
import 'package:farm/domain/usecases/cattle_by_rfid_use_case.dart';
import 'package:farm/domain/usecases/get_user_data_use_case.dart';
import 'package:farm/domain/usecases/mutation_item_add_use_case.dart';
import 'package:farm/features/mutation/item_add/bloc/mutation_item_add_event.dart';
import 'package:farm/features/mutation/item_add/bloc/mutation_item_add_state.dart';
import 'package:farm/features/sales/add/model/list_item.dart';
import 'package:farm/helper/run_catching/result.dart';
import 'package:farm/helper/run_catching/run_catching.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MutationItemAddBloc
    extends BaseBloc<MutationItemAddEvent, MutationItemAddState> {
  final CattleByRFIDUseCase _cattleUseCase;
  final GetUserDataUseCase _userDataUseCase;
  final MutationItemAddUseCase _mutationItemAddUseCase;

  MutationItemAddBloc(
    this._cattleUseCase,
    this._userDataUseCase,
    this._mutationItemAddUseCase,
  ) : super(const MutationItemAddState()) {
    on<Initiated>(_initialized, transformer: log());
    on<OnSubmit>(_onSubmit, transformer: log());
    on<IsSuccessChanged>((event, emit) {
      emit(state.copyWith(isSuccess: event.value));
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<MutationItemAddState> emit,
  ) async {
    final cattle = event.cattle ?? const Cattle();
    final items = _getCattleItems(cattle);

    emit(
      state.copyWith(
        item: event.item,
        cattle: cattle,
        listItems: items,
        rfid: event.rfid.orEmpty(),
      ),
    );
    if (event.rfid?.isNotEmpty == true) {
      await _cattleApi(event.rfid.orEmpty(), emit);
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
    Emitter<MutationItemAddState> emit,
  ) async {
    emit(state.copyWith(errorMessage: ''));
    if (state.cattle.id == '') {
      emit(
        state.copyWith(
          errorMessage:
              'Identitas sapi tidak ditemukan, silakan kembali untuk untuk memindai sapi / mencari data sapi menggunakan ear tag',
        ),
      );
      return;
    }
    await _onSubmitApi(emit);
  }

  Future<void> _cattleApi(String rfid, Emitter<MutationItemAddState> emit) {
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

  Future<void> _onSubmitApi(Emitter<MutationItemAddState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, isSuccess: false));
        final payload = MutationItemAddRequest(
          id_mutation: state.item.id,
          id_cattles: [state.cattle.id],
        );
        final response = await _mutationItemAddUseCase.execute(payload);
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

  bool _isProjectChosen(Emitter<MutationItemAddState> emit) {
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
        name: 'Berat',
        description: '${data.actual_weight.toString()} KG',
      ),
      ListItem(name: 'Ras', description: data.id_breed),
      ListItem(name: 'Jenis Kelamin', description: data.genderLabel()),
      ListItem(name: 'Status', description: data.statusLabel()),
    ];
    return items;
  }
}
