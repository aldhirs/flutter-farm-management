import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/sales/sales_item_delete_request.dart';
import 'package:farm/domain/entities/sales/sales_item_request.dart';
import 'package:farm/domain/usecases/sales_item_delete_use_case.dart';
import 'package:farm/domain/usecases/sales_items_use_case.dart';
import 'package:farm/features/sales_items/bloc/sales_items_event.dart';
import 'package:farm/features/sales_items/bloc/sales_items_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SalesItemsBloc extends BaseBloc<SalesItemsEvent, SalesItemsState> {
  final SalesItemsUseCase _salesItemsUseCase;
  final SalesItemDeleteUseCase _salesItemDeleteUseCase;
  final limit = 8;
  SalesItemsBloc(this._salesItemsUseCase, this._salesItemDeleteUseCase)
    : super(const SalesItemsState()) {
    on<Initiated>(_initialized, transformer: log());
    on<Load>(_load, transformer: log());
    on<LoadMore>(_loadMore, transformer: log());
    on<EditModeToggled>(_onEditModeToggled, transformer: log());
    on<ItemSelectionToggled>(_onItemSelectionToggled, transformer: log());
    on<DeleteSalesItems>(_onDeleteSalesItems, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<SalesItemsState> emit,
  ) async {
    emit(state.copyWith(sales: event.item));
    await _loadApi(emit, false, 1, false);
  }

  Future<void> _load(Load event, Emitter<SalesItemsState> emit) async {
    await _loadApi(emit, event.withFilter, 1, false);
  }

  Future<void> _loadMore(LoadMore event, Emitter<SalesItemsState> emit) async {
    if (state.isLoadMore || !state.hasMore) return;
    emit(state.copyWith(isLoadMore: true));
    final nextPage = (state.salesItems.length ~/ limit) + 1;
    await _loadApi(emit, true, nextPage, true);
  }

  Future<void> _loadApi(
    Emitter<SalesItemsState> emit,
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
        final req = SalesItemRequest(
          limit: limit,
          id_sale: state.sales.id,
          page: nextPage,
        );
        final response = await _salesItemsUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            var items = data;
            if (isLoadMore) {
              items = [...state.salesItems, ...data];
            }
            emit(
              state.copyWith(
                salesItems: items,
                isEditMode: false,
                selectedItems: [],
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

  bool _isProjectChosen(Emitter<SalesItemsState> emit) {
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

  void _onEditModeToggled(
    EditModeToggled event,
    Emitter<SalesItemsState> emit,
  ) {
    emit(state.copyWith(isEditMode: !state.isEditMode, selectedItems: []));
  }

  void _onItemSelectionToggled(
    ItemSelectionToggled event,
    Emitter<SalesItemsState> emit,
  ) {
    final updated = [...state.selectedItems];
    if (updated.contains(event.item)) {
      updated.remove(event.item);
    } else {
      updated.add(event.item);
    }
    emit(state.copyWith(selectedItems: updated));
  }

  Future<void> _onDeleteSalesItems(
    DeleteSalesItems event,
    Emitter<SalesItemsState> emit,
  ) async {
    await _deleteApi(emit);
  }

  Future<void> _deleteApi(Emitter<SalesItemsState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        final req = SalesItemDeleteRequest(
          sale_id: state.sales.id,
          items: state.selectedItems,
        );
        final response = await _salesItemDeleteUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                successMessage: 'Item penjualan berhasil dihapus.',
              ),
            );
            add(const Load());
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
}
