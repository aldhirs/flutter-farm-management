import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle_pen_to_pen_request.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/usecases/cattle_move_to_pen_use_case.dart';
import 'package:farm/domain/usecases/pens_use_case.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_event.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class PenDraftingBloc extends BaseBloc<PenDraftingEvent, PenDraftingState> {
  final PensUseCase _pensUseCase;
  final CattleMoveToPenUseCase _cattleMoveToPenUseCase;
  final limit = 8;
  PenDraftingBloc(this._pensUseCase, this._cattleMoveToPenUseCase)
    : super(const PenDraftingState()) {
    on<Initiated>(_initialized, transformer: log());
    on<Load>(_load, transformer: log());
    on<LoadMore>(_loadMore, transformer: log());
    on<GetPens>(_getPensApi, transformer: log());
    on<OnSubmitMoveToPen>(_onSubmitMoveToPen, transformer: log());
    on<PenChanged>((event, emit) {
      emit(state.copyWith(selectedPen: event.pen));
    }, transformer: log());
    on<FilterStatusChanged>((event, emit) {
      emit(state.copyWith(filterStatus: event.value));
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<PenDraftingState> emit,
  ) async {
    await _loadApi(emit, false, 1, false);
  }

  Future<void> _load(Load event, Emitter<PenDraftingState> emit) async {
    await _loadApi(emit, event.withFilter, 1, false);
  }

  Future<void> _loadMore(LoadMore event, Emitter<PenDraftingState> emit) async {
    if (state.isLoadMore || !state.hasMore) return;
    emit(state.copyWith(isLoadMore: true));
    final nextPage = (state.items.length ~/ limit) + 1;
    await _loadApi(emit, true, nextPage, true);
  }

  Future<void> _loadApi(
    Emitter<PenDraftingState> emit,
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
        var category = 'Penggemukan,Karantina,Isolasi,Penjualan';
        if (state.filterStatus.isNotEmpty) {
          category = state.filterStatus;
        }
        final req = PenRequest(
          limit: limit,
          projectId: appBloc.state.selectedProject?.id ?? '',
          barnCategory: category,
          page: nextPage,
        );
        final response = await _pensUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            final errorMessage = data.isEmpty ? 'Data tidak ditemukan' : '';
            var items = data;
            if (isLoadMore) {
              items = [...state.items, ...data];
            }
            emit(
              state.copyWith(
                items: items,
                successMessage: '',
                errorMessage: errorMessage,
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
      doOnEventCompleted: () async {
        emit(state.copyWith(errorSnackMessage: ''));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _getPensApi(GetPens event, Emitter<PenDraftingState> emit) {
    return runBlocCatching(
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _pensUseCase.execute(
          PenRequest(
            projectId: appBloc.state.selectedProject!.id,
            barnCategory: 'Penggemukan,Karantina,Isolasi,Penjualan',
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(dropdownPens: data, errorMessage: ''));
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

  Future<void> _onSubmitMoveToPen(
    OnSubmitMoveToPen event,
    Emitter<PenDraftingState> emit,
  ) {
    return runBlocCatching(
      action: () async {
        if (state.selectedPen == null) {
          emit(
            state.copyWith(
              errorSnackMessage: 'Pilih pen tujuan terlebih dahulu',
            ),
          );
          return;
        }
        emit(state.copyWith(loading: true));
        final response = await _cattleMoveToPenUseCase.execute(
          CattlePenToPenRequest(
            from_pen_id: event.fromPen.id,
            to_pen_id: (state.selectedPen?.id).orEmpty(),
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                successMessage: 'Pen berhasil dipindahkan.',
                errorSnackMessage: '',
                selectedPen: null,
              ),
            );
            add(const Load());
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorSnackMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorSnackMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  bool _isProjectChosen(Emitter<PenDraftingState> emit) {
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
