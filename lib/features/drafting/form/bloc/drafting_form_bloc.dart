import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/cattle/cattle_form_request.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/level/level_request.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/usecases/barns_use_case.dart';
import 'package:farm/domain/usecases/cattle_by_rfid_use_case.dart';
import 'package:farm/domain/usecases/cattle_update_use_case.dart';
import 'package:farm/domain/usecases/get_user_data_use_case.dart';
import 'package:farm/domain/usecases/levels_use_case.dart';
import 'package:farm/domain/usecases/pens_use_case.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/model/list_item.dart';
import 'package:farm/helper/run_catching/result.dart';
import 'package:farm/helper/run_catching/run_catching.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DraftingFormBloc extends BaseBloc<DraftingFormEvent, DraftingFormState> {
  final CattleByRFIDUseCase _cattleUseCase;
  final GetUserDataUseCase _userDataUseCase;
  final BarnsUseCase _barnsUseCase;
  final PensUseCase _pensUseCase;
  final LevelsUseCase _levelsUseCase;
  final CattleUpdateUseCase _cattleUpdateUseCase;
  // BluetoothConnection? _connection;
  // StreamSubscription? _readSubscription;

  DraftingFormBloc(
    this._cattleUseCase,
    this._userDataUseCase,
    this._barnsUseCase,
    this._pensUseCase,
    this._levelsUseCase,
    this._cattleUpdateUseCase,
  ) : super(const DraftingFormState()) {
    on<Initiated>(_initialized, transformer: log());
    on<IdentityInit>(_identityInit, transformer: log());
    on<OnSubmitIdentity>(_onSubmitIdentity, transformer: log());
    on<IdentitySuccessChanged>((event, emit) {
      emit(state.copyWith(isIdentitySuccess: event.value));
    }, transformer: log());
    on<GrowthSuccessChanged>((event, emit) {
      emit(state.copyWith(isGrowthSuccess: event.value));
    }, transformer: log());
    on<TreatmentSuccessChanged>((event, emit) {
      emit(state.copyWith(isTreatmentSuccess: event.value));
    }, transformer: log());
    on<MedicSuccessChanged>((event, emit) {
      emit(state.copyWith(isIdentitySuccess: event.value));
    }, transformer: log());
    on<BarnChanged>((event, emit) {
      emit(state.copyWith(selectedBarn: event.barn));
      add(GetPens(barnId: event.barn.id));
    }, transformer: log());
    on<PenChanged>((event, emit) {
      emit(state.copyWith(selectedPen: event.pen));
    }, transformer: log());
    on<EarTagChanged>((event, emit) {
      emit(
        state.copyWith(
          earTag: event.value,
          isLevelError: event.value.isNotEmpty,
        ),
      );
    }, transformer: log());
    on<LevelChanged>((event, emit) {
      emit(state.copyWith(selectedLevel: event.value));
    }, transformer: log());
    on<GetPens>(_getPensApi, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<DraftingFormState> emit,
  ) async {
    await _cattleApi(event.rfid, emit);

    // user data
    final user = switch (runCatching(
      action: () => _userDataUseCase.execute(const GetUserDataInput()),
    )) {
      ResultSuccess(:final data) => data,
      _ => const UserData(),
    };
    emit(state.copyWith(userData: user));
  }

  Future<void> _identityInit(
    IdentityInit event,
    Emitter<DraftingFormState> emit,
  ) async {
    await _barnsApi(emit);
    await _getLevelsApi(emit);
  }

  Future<void> _onSubmitIdentity(
    OnSubmitIdentity event,
    Emitter<DraftingFormState> emit,
  ) async {
    emit(state.copyWith(identityErrorMessage: ''));
    if (state.selectedBarn == null ||
        state.selectedLevel == null ||
        state.selectedPen == null ||
        state.earTag == null) {
      emit(
        state.copyWith(
          identityErrorMessage:
              'Harap mengisi kandang, pen, grade atau ear tag.',
        ),
      );
      return;
    }
    await _submitIdentityApi(emit);
  }

  @override
  Future<void> close() async {
    // _connection?.dispose();
    // _readSubscription?.cancel();
    super.close();
  }

  Future<void> _cattleApi(String rfid, Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      action: () async {
        emit(state.copyWith(loading: true));
        final response = await _cattleUseCase.execute(
          CattleRequest(rfid: rfid),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            final items = [
              ListItem(name: 'ID', description: data.id),
              ListItem(name: 'RFID', description: data.rfid_tag),
              ListItem(
                name: 'Kandang',
                description: data.pen?.name_barn ?? '-',
              ),
              ListItem(name: 'Pen', description: data.pen?.name ?? '-'),
              ListItem(name: 'Ear Tag', description: data.ear_tag),
              ListItem(
                name: 'Berat',
                description: '${data.actual_weight.toString()} KG',
              ),
              ListItem(name: 'Breed', description: data.id_breed),
              ListItem(name: 'Jenis Kelamin', description: data.gender),
              ListItem(name: 'Status', description: data.status),
            ];
            Barn? barn;
            Pen? pen;
            if (data.pen != null) {
              barn = Barn(
                id: data.pen?.id_barn ?? '',
                name: data.pen?.name_barn ?? '',
              );
              pen = data.pen;
              add(GetPens(barnId: data.pen?.id_barn ?? ''));
            }

            emit(
              state.copyWith(
                cattle: data,
                selectedBarn: barn,
                selectedPen: pen,
                selectedLevel: data.level,
                earTag: data.ear_tag,
                listItems: items,
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
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _barnsApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _barnsUseCase.execute(
          BarnRequest(projectId: appBloc.state.selectedProject!.id),
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

  Future<void> _getPensApi(GetPens event, Emitter<DraftingFormState> emit) {
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

  Future<void> _getLevelsApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      action: () async {
        final response = await _levelsUseCase.execute(
          LevelRequest(clientSlug: appBloc.state.userData?.clientSlug ?? ''),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(levels: data, errorMessage: ''));
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

  Future<void> _submitIdentityApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, isIdentitySuccess: false));
        final cattle = state.cattle;
        final response = await _cattleUpdateUseCase.execute(
          CattleFormRequest(
            id: cattle.id,
            barn_id: state.selectedBarn?.id ?? '',
            pen_id: state.selectedPen?.id ?? '',
            supplier_id: cattle.id_supplier,
            breed_id: cattle.id_breed,
            ear_tag: state.earTag.orEmpty(),
            level_id: state.selectedLevel?.id ?? 0,
            reception_id: cattle.reception?.id ?? '',
            status: cattle.status,
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                isIdentitySuccess: true,
                errorMessage: '',
                identityErrorMessage: '',
              ),
            );
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(identityErrorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: true,
      doOnError: (e) async {
        emit(
          state.copyWith(identityErrorMessage: exceptionMessageMapper.map(e)),
        );
      },
    );
  }

  bool _isProjectChosen(Emitter<DraftingFormState> emit) {
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
}
