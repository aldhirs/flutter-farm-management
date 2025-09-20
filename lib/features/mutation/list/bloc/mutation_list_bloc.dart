import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/mutation/mutation_request.dart';
import 'package:farm/domain/usecases/mutations_use_case.dart';
import 'package:farm/features/mutation/list/bloc/mutation_list_event.dart';
import 'package:farm/features/mutation/list/bloc/mutation_list_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MutationListBloc extends BaseBloc<MutationListEvent, MutationListState> {
  final MutationsUseCase _mutationsUseCase;
  final limit = 8;
  MutationListBloc(this._mutationsUseCase) : super(const MutationListState()) {
    on<Initiated>(_initialized, transformer: log());
    on<LoadMutationList>(_loadMutationList, transformer: log());
    on<LoadMoreMutationList>(_loadMoreMutationList, transformer: log());
    on<FilterStatusChanged>((event, emit) {
      emit(state.copyWith(filterStatus: event.value));
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<MutationListState> emit,
  ) async {
    final status = mutationStatusMap.entries
        .firstWhere((item) => item.key == DRAFT)
        .value;
    emit(state.copyWith(isIn: event.isIn, filterStatus: status));
    await _mutationApi(emit, true, 1, false);
  }

  Future<void> _loadMutationList(
    LoadMutationList event,
    Emitter<MutationListState> emit,
  ) async {
    await _mutationApi(emit, event.withFilter, 1, false);
  }

  Future<void> _loadMoreMutationList(
    LoadMoreMutationList event,
    Emitter<MutationListState> emit,
  ) async {
    if (state.isLoadMore || !state.hasMore) return;
    emit(state.copyWith(isLoadMore: true));
    final nextPage = (state.items.length ~/ limit) + 1;
    await _mutationApi(emit, true, nextPage, true);
  }

  Future<void> _mutationApi(
    Emitter<MutationListState> emit,
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
        var status = '';
        if (withFilter && state.filterStatus.isNotEmpty) {
          status = salesStatusMap.entries
              .firstWhere((item) => item.value == state.filterStatus)
              .key;
        }
        final req = MutationRequest(
          limit: limit,
          from_project_id: !state.isIn
              ? appBloc.state.selectedProject?.id ?? ''
              : '',
          to_project_id: state.isIn
              ? appBloc.state.selectedProject?.id ?? ''
              : '',
          status: status,
          page: nextPage,
        );
        final response = await _mutationsUseCase.execute(req);
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

  bool _isProjectChosen(Emitter<MutationListState> emit) {
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
