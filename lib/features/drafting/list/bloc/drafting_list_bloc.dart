import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle_list_request.dart';
import 'package:farm/domain/usecases/cattles_use_case.dart';
import 'package:farm/features/drafting/list/bloc/drafting_list_event.dart';
import 'package:farm/features/drafting/list/bloc/drafting_list_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DraftingListBloc extends BaseBloc<DraftingListEvent, DraftingListState> {
  final CattlesUseCase _cattlesUseCase;

  static const int limit = 20;

  DraftingListBloc(this._cattlesUseCase) : super(const DraftingListState()) {
    on<Initiated>((event, emit) => _load(emit, 1, false), transformer: log());
    on<Refreshed>((event, emit) => _load(emit, 1, false), transformer: log());
    on<LoadMore>(_loadMore, transformer: log());
  }

  Future<void> _loadMore(
    LoadMore event,
    Emitter<DraftingListState> emit,
  ) async {
    if (state.isLoadMore || !state.hasMore) return;
    emit(state.copyWith(isLoadMore: true));
    await _load(emit, state.page + 1, true);
  }

  /// Memuat ternak yang masih menunggu didrafting di feedlot yang dipilih.
  ///
  /// Saringannya dikerjakan server lewat `drafted=no`, bukan disaring lagi di
  /// sini. Menyaring ulang di aplikasi akan memecah halaman: server memotong 20
  /// baris pertama menurut aturannya, lalu aplikasi membuang sebagian, dan
  /// halaman berikutnya melewatkan baris yang seharusnya ikut.
  Future<void> _load(
    Emitter<DraftingListState> emit,
    int page,
    bool isLoadMore,
  ) {
    return runBlocCatching(
      handleLoading: !isLoadMore,
      handleError: false,
      action: () async {
        final project = appBloc.state.selectedProject;
        if (project == null || project.id.isEmpty) {
          emit(
            state.copyWith(
              errorMessage: 'Anda harus memilih feedlot terlebih dahulu.',
            ),
          );
          return;
        }

        final response = await _cattlesUseCase.execute(
          CattleListRequest(
            id_project: project.id,
            drafted: 'no',
            page: page,
            limit: limit,
          ),
        );

        switch (response.result) {
          case DataSuccess(:final data):
            final items = isLoadMore ? [...state.items, ...data] : data;
            final currentPage = response.page ?? page;
            emit(
              state.copyWith(
                items: items,
                errorMessage: '',
                total: response.total ?? items.length,
                page: currentPage,
                hasMore: (response.total_page ?? 1) > currentPage,
                isLoadMore: false,
              ),
            );
          case DataError(:final errorMessage):
            emit(
              state.copyWith(
                errorMessage: errorMessage.orEmpty(),
                isLoadMore: false,
              ),
            );
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(isLoadMore: false));
      },
      doOnError: (e) async {
        emit(
          state.copyWith(
            errorMessage: exceptionMessageMapper.map(e),
            isLoadMore: false,
          ),
        );
      },
    );
  }
}
