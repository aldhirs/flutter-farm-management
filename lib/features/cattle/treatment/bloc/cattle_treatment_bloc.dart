import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/treatment/treatment_request.dart';
import 'package:farm/domain/usecases/treatments_use_case.dart';
import 'package:farm/features/cattle/treatment/bloc/cattle_treatment_event.dart';
import 'package:farm/features/cattle/treatment/bloc/cattle_treatment_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CattleTreatmentBloc
    extends BaseBloc<CattleTreatmentEvent, CattleTreatmentState> {
  final TreatmentsUseCase _salesUseCase;
  final limit = 8;
  CattleTreatmentBloc(this._salesUseCase)
    : super(const CattleTreatmentState()) {
    on<Initiated>(_initialized, transformer: log());
    on<LoadCattleTreatment>(_loadCattleTreatment, transformer: log());
    on<LoadMoreCattleTreatment>(_loadMoreCattleTreatment, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<CattleTreatmentState> emit,
  ) async {
    emit(state.copyWith(cattle: event.cattle));
    await _api(emit, false, 1, false);
  }

  Future<void> _loadCattleTreatment(
    LoadCattleTreatment event,
    Emitter<CattleTreatmentState> emit,
  ) async {
    await _api(emit, event.withFilter, 1, false);
  }

  Future<void> _loadMoreCattleTreatment(
    LoadMoreCattleTreatment event,
    Emitter<CattleTreatmentState> emit,
  ) async {
    if (state.isLoadMore || !state.hasMore) return;
    emit(state.copyWith(isLoadMore: true));
    final nextPage = (state.items.length ~/ limit) + 1;
    await _api(emit, true, nextPage, true);
  }

  Future<void> _api(
    Emitter<CattleTreatmentState> emit,
    bool withFilter,
    int nextPage,
    bool isLoadMore,
  ) {
    return runBlocCatching(
      handleLoading: !isLoadMore,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final req = TreatmentRequest(
          limit: limit,
          id_project: appBloc.state.selectedProject?.id ?? '',
          id_cattle: state.cattle.id,
          page: nextPage,
        );
        final response = await _salesUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            var items = data;
            if (isLoadMore) {
              items = [...state.items, ...data];
            }
            emit(
              state.copyWith(
                items: items,
                errorMessage: '',
                hasMore: (response.total_page ?? 1) > (response.page ?? 1),
                isLoadMore: false,
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

  bool _isProjectChosen(Emitter<CattleTreatmentState> emit) {
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
