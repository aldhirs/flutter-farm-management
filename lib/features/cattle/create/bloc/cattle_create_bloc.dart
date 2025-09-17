import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/breed/breed_request.dart';
import 'package:farm/domain/entities/cattle/cattle_form_request.dart';
import 'package:farm/domain/entities/level/level_request.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/reception/reception_request.dart';
import 'package:farm/domain/entities/supplier/supplier_request.dart';
import 'package:farm/domain/usecases/barns_use_case.dart';
import 'package:farm/domain/usecases/breeds_use_case.dart';
import 'package:farm/domain/usecases/cattle_create_use_case.dart';
import 'package:farm/domain/usecases/get_user_data_use_case.dart';
import 'package:farm/domain/usecases/levels_use_case.dart';
import 'package:farm/domain/usecases/pens_use_case.dart';
import 'package:farm/domain/usecases/receptions_use_case.dart';
import 'package:farm/domain/usecases/suppliers_use_case.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_event.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_state.dart';
import 'package:farm/helper/run_catching/result.dart';
import 'package:farm/helper/run_catching/run_catching.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CattleCreateBloc extends BaseBloc<CattleCreateEvent, CattleCreateState> {
  final GetUserDataUseCase _userDataUseCase;
  final BarnsUseCase _barnsUseCase;
  final PensUseCase _pensUseCase;
  final BreedsUseCase _breedsUseCase;
  final LevelsUseCase _levelsUseCase;
  final SuppliersUseCase _suppliersUseCase;
  final ReceptionsUseCase _receptionsUseCase;

  final CattleCreateUseCase _cattleCreateUseCase;

  CattleCreateBloc(
    this._userDataUseCase,
    this._barnsUseCase,
    this._pensUseCase,
    this._cattleCreateUseCase,
    this._breedsUseCase,
    this._levelsUseCase,
    this._suppliersUseCase,
    this._receptionsUseCase,
  ) : super(const CattleCreateState()) {
    on<Initiated>(_initialized, transformer: log());
    on<OnSubmit>(_onSubmit, transformer: log());
    on<GetBarns>(_barnsApi, transformer: log());
    on<GetPens>(_getPensApi, transformer: log());
    on<GetBreeds>(_breedsApi, transformer: log());
    on<GetLevels>(_levelsApi, transformer: log());
    on<GetReceptions>(_receptionsApi, transformer: log());
    on<GetSuppliers>(_suppliersApi, transformer: log());
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
    on<EarTagChanged>((event, emit) {
      emit(state.copyWith(earTag: event.value));
    }, transformer: log());
    on<BreedChanged>((event, emit) {
      emit(state.copyWith(selectedBreed: event.value));
    }, transformer: log());
    on<LevelChanged>((event, emit) {
      emit(state.copyWith(selectedLevel: event.value));
    }, transformer: log());
    on<SupplierChanged>((event, emit) {
      emit(state.copyWith(selectedSupplier: event.value));
    }, transformer: log());
    on<ReceptionChanged>((event, emit) {
      emit(state.copyWith(selectedReception: event.value));
    }, transformer: log());
    on<GenderChanged>((event, emit) {
      emit(state.copyWith(selectedGender: event.value));
    }, transformer: log());
    on<OnClear>((event, emit) {
      emit(
        state.copyWith(
          selectedBarn: null,
          selectedBreed: null,
          selectedGender: null,
          selectedLevel: null,
          selectedPen: null,
          selectedReception: null,
          selectedSupplier: null,
          earTag: null,
          errorMessage: '',
        ),
      );
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<CattleCreateState> emit,
  ) async {
    // add(const GetBarns());
    add(const GetBreeds());
    add(const GetLevels());
    add(const GetReceptions());
    add(const GetSuppliers());

    // user data
    final user = switch (runCatching(
      action: () => _userDataUseCase.execute(const GetUserDataInput()),
    )) {
      ResultSuccess(:final data) => data,
      _ => const UserData(),
    };
    emit(state.copyWith(userData: user, rfid: event.rfid.orEmpty()));
  }

  Future<void> _onSubmit(
    OnSubmit event,
    Emitter<CattleCreateState> emit,
  ) async {
    emit(state.copyWith(errorMessage: ''));
    if (state.selectedBreed == null ||
        state.selectedGender == null ||
        state.selectedLevel == null ||
        state.selectedReception == null ||
        state.selectedSupplier == null ||
        state.earTag?.isEmpty == true) {
      emit(
        state.copyWith(
          errorMessage: 'Harap mengisi formulir terlebih dahulu.',
          isFormValid: false,
        ),
      );
      return;
    }
    await _onSubmitApi(emit);
  }

  Future<void> _barnsApi(GetBarns event, Emitter<CattleCreateState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _barnsUseCase.execute(
          BarnRequest(
            projectId: appBloc.state.selectedProject!.id,
            category: barnCategoryMap.keys.join(","),
            search: event.search.orEmpty(),
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

  Future<void> _breedsApi(GetBreeds event, Emitter<CattleCreateState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _breedsUseCase.execute(
          BreedRequest(
            client_slug: (appBloc.state.userData?.clientSlug).orEmpty(),
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(breeds: data, errorMessage: ''));
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

  Future<void> _levelsApi(GetLevels event, Emitter<CattleCreateState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _levelsUseCase.execute(
          LevelRequest(
            clientSlug: (appBloc.state.userData?.clientSlug).orEmpty(),
          ),
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
      doOnEventCompleted: () async {},
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _suppliersApi(
    GetSuppliers event,
    Emitter<CattleCreateState> emit,
  ) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _suppliersUseCase.execute(
          SupplierRequest(
            client_slug: (appBloc.state.userData?.clientSlug).orEmpty(),
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(suppliers: data, errorMessage: ''));
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

  Future<void> _receptionsApi(
    GetReceptions event,
    Emitter<CattleCreateState> emit,
  ) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _receptionsUseCase.execute(
          ReceptionRequest(
            search: event.search.orEmpty(),
            id_project: appBloc.state.selectedProject!.id,
            client_slug: (appBloc.state.userData?.clientSlug).orEmpty(),
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                receptions: data,
                errorMessage: '',
                selectedReception: null,
              ),
            );
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

  Future<void> _getPensApi(GetPens event, Emitter<CattleCreateState> emit) {
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

  Future<void> _onSubmitApi(Emitter<CattleCreateState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(
          state.copyWith(loading: true, isSuccess: false, isFormValid: true),
        );
        final payload = CattleFormRequest(
          rfid: state.rfid,
          project_id: (appBloc.state.selectedProject?.id).orEmpty(),
          // barn_id: (state.selectedBarn?.id).orEmpty(),
          // pen_id: (state.selectedPen?.id).orEmpty(),
          breed_id: (state.selectedBreed?.id).orEmpty(),
          level_id: state.selectedLevel?.id ?? 0,
          supplier_id: (state.selectedSupplier?.id).orEmpty(),
          reception_id: (state.selectedReception?.id).orEmpty(),
          ear_tag: (state.earTag).orEmpty(),
          gender: (state.selectedGender).orEmpty(),
        );
        final response = await _cattleCreateUseCase.execute(payload);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(cattle: data, isSuccess: true, errorMessage: ''),
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

  bool _isProjectChosen(Emitter<CattleCreateState> emit) {
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
