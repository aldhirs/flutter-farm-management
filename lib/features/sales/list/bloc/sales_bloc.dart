import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/sales/sales_request.dart';
import 'package:farm/domain/usecases/sales_use_case.dart';
import 'package:farm/features/sales/list/bloc/sales_event.dart';
import 'package:farm/features/sales/list/bloc/sales_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SalesBloc extends BaseBloc<SalesEvent, SalesState> {
  final SalesUseCase _salesUseCase;
  final limit = 8;
  SalesBloc(this._salesUseCase) : super(const SalesState()) {
    on<Initiated>(_initialized, transformer: log());
    on<LoadSales>(_loadSales, transformer: log());
    on<LoadMoreSales>(_loadMoreSales, transformer: log());
    on<FilterStatusChanged>((event, emit) {
      emit(state.copyWith(filterStatus: event.value));
    }, transformer: log());
  }

  Future<void> _initialized(Initiated event, Emitter<SalesState> emit) async {
    final status = salesStatusMap.entries
        .firstWhere((item) => item.key == DRAFT)
        .value;
    emit(state.copyWith(filterStatus: status));
    await _salesApi(emit, true, 1, false);
  }

  Future<void> _loadSales(LoadSales event, Emitter<SalesState> emit) async {
    await _salesApi(emit, event.withFilter, 1, false);
  }

  Future<void> _loadMoreSales(
    LoadMoreSales event,
    Emitter<SalesState> emit,
  ) async {
    if (state.isLoadMore || !state.hasMore) return;
    emit(state.copyWith(isLoadMore: true));
    final nextPage = (state.sales.length ~/ limit) + 1;
    await _salesApi(emit, true, nextPage, true);
  }

  Future<void> _salesApi(
    Emitter<SalesState> emit,
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
        final req = SalesRequest(
          limit: limit,
          id_project: appBloc.state.selectedProject?.id ?? '',
          status: status,
          page: nextPage,
        );
        final response = await _salesUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            var items = data;
            if (isLoadMore) {
              items = [...state.sales, ...data];
            }
            emit(
              state.copyWith(
                sales: items,
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

  bool _isProjectChosen(Emitter<SalesState> emit) {
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
