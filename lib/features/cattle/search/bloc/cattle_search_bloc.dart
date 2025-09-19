import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/medical/medical_request.dart';
import 'package:farm/domain/entities/treatment/treatment_request.dart';
import 'package:farm/domain/usecases/cattle_by_rfid_use_case.dart';
import 'package:farm/domain/usecases/medicals_use_case.dart';
import 'package:farm/domain/usecases/treatments_use_case.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_event.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CattleSearchBloc extends BaseBloc<CattleSearchEvent, CattleSearchState> {
  final CattleByRFIDUseCase _cattleByRFIDUseCase;
  final TreatmentsUseCase _treatmentsUseCase;
  final MedicalsUseCase _medicalsUseCase;
  CattleSearchBloc(
    this._cattleByRFIDUseCase,
    this._treatmentsUseCase,
    this._medicalsUseCase,
  ) : super(const CattleSearchState()) {
    on<Initiated>(_initialized, transformer: log());
    on<CheckCattle>(_getCattleApi, transformer: log());
    on<GetTreatments>(_getTreatmentsApi, transformer: log());
    on<GetMedicals>(_getMedicalsApi, transformer: log());
    on<EarTagChanged>((event, emit) {
      emit(state.copyWith(earTag: event.value, errorMessage: ''));
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<CattleSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        earTag: "ear-0001",
        cattle: event.cattle,
        rfid: event.rfid.orEmpty(),
      ),
    );
    if (event.rfid != null) {
      add(const CheckCattle());
    } else {
      add(GetTreatments(id_cattle: (event.cattle?.id).orEmpty()));
      add(GetMedicals(id_cattle: (event.cattle?.id).orEmpty()));
    }
  }

  Future<void> _getCattleApi(
    CheckCattle event,
    Emitter<CattleSearchState> emit,
  ) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, cattle: null));
        final req = CattleRequest(
          id_project: appBloc.state.selectedProject?.id ?? '',
          rfid: state.rfid.orEmpty(),
        );
        final response = await _cattleByRFIDUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            add(GetTreatments(id_cattle: data.id));
            add(GetMedicals(id_cattle: data.id));
            emit(state.copyWith(cattle: data, errorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(
              state.copyWith(
                cattle: null,
                treatments: [],
                medicals: [],
                errorMessage: errorMessage.orEmpty(),
              ),
            );
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

  Future<void> _getTreatmentsApi(
    GetTreatments event,
    Emitter<CattleSearchState> emit,
  ) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, treatments: []));
        final req = TreatmentRequest(
          id_project: appBloc.state.selectedProject?.id ?? '',
          client_slug: (appBloc.state.userData?.clientSlug).orEmpty(),
          id_cattle: event.id_cattle,
          limit: 3,
        );
        final response = await _treatmentsUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(treatments: data, errorMessage: ''));
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

  Future<void> _getMedicalsApi(
    GetMedicals event,
    Emitter<CattleSearchState> emit,
  ) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, medicals: []));
        final req = MedicalRequest(
          id_project: appBloc.state.selectedProject?.id ?? '',
          client_slug: (appBloc.state.userData?.clientSlug).orEmpty(),
          id_cattle: event.id_cattle,
          limit: 3,
        );
        final response = await _medicalsUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(medicals: data, errorMessage: ''));
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

  bool _isProjectChosen(Emitter<CattleSearchState> emit) {
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
