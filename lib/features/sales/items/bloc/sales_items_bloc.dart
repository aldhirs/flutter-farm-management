import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/sales/sales_item_delete_request.dart';
import 'package:farm/domain/entities/sales/sales_item_move_request.dart';
import 'package:farm/domain/entities/sales/sales_item_request.dart';
import 'package:farm/domain/entities/sales/sales_request.dart';
import 'package:farm/domain/usecases/barns_use_case.dart';
import 'package:farm/domain/usecases/cattle_by_ear_tag_use_case.dart';
import 'package:farm/domain/usecases/pens_use_case.dart';
import 'package:farm/domain/usecases/sales_item_delete_use_case.dart';
import 'package:farm/domain/usecases/sales_item_move_use_case.dart';
import 'package:farm/domain/usecases/sales_items_use_case.dart';
import 'package:farm/domain/usecases/sales_use_case.dart';
import 'package:farm/features/sales/items/bloc/sales_items_event.dart';
import 'package:farm/features/sales/items/bloc/sales_items_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SalesItemsBloc extends BaseBloc<SalesItemsEvent, SalesItemsState> {
  final SalesUseCase _salesUseCase;
  final CattleByEarTagUseCase _cattleByEarTagUseCase;
  final SalesItemsUseCase _salesItemsUseCase;
  final SalesItemDeleteUseCase _salesItemDeleteUseCase;
  final SalesItemMoveUseCase _salesItemMoveUseCase;
  final BarnsUseCase _barnsUseCase;
  final PensUseCase _pensUseCase;
  final limit = 8;
  SalesItemsBloc(
    this._cattleByEarTagUseCase,
    this._barnsUseCase,
    this._salesUseCase,
    this._pensUseCase,
    this._salesItemsUseCase,
    this._salesItemDeleteUseCase,
    this._salesItemMoveUseCase,
  ) : super(const SalesItemsState()) {
    on<Initiated>(_initialized, transformer: log());
    on<Load>(_load, transformer: log());
    on<LoadMore>(_loadMore, transformer: log());
    on<EditModeToggled>(_onEditModeToggled, transformer: log());
    on<ItemSelectionToggled>(_onItemSelectionToggled, transformer: log());
    on<DeleteSalesItems>(_onDeleteSalesItems, transformer: log());
    on<OnSubmitMoveSale>(_onMoveSalesItems, transformer: log());
    on<GetBarns>(_getBarnsApi, transformer: log());
    on<GetPens>(_getPensApi, transformer: log());
    on<SalesList>(_getSalesApi, transformer: log());
    on<CheckCattleEarTag>(_getCattleEarTagApi, transformer: log());
    ;
    on<BarnChanged>((event, emit) {
      emit(state.copyWith(selectedBarn: event.barn, selectedPen: null));
      add(GetPens(barnId: event.barn.id));
    }, transformer: log());
    on<EarTagChanged>((event, emit) {
      emit(state.copyWith(earTag: event.value, earTagErrorMessage: ''));
    }, transformer: log());
    on<PenChanged>((event, emit) {
      emit(state.copyWith(selectedPen: event.pen));
    }, transformer: log());
    on<SaleChanged>((event, emit) {
      emit(state.copyWith(selectedSale: event.sale));
    }, transformer: log());
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

  Future<void> _onMoveSalesItems(
    OnSubmitMoveSale event,
    Emitter<SalesItemsState> emit,
  ) async {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        final ids = state.selectedItems.map((e) => e.id).toList();
        final req = SalesItemMoveRequest(
          sale_id: state.sales.id,
          to_sale_id: (state.selectedSale?.id).orEmpty(),
          sale_item_ids: ids,
        );
        final response = await _salesItemMoveUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                successMessage: 'Item penjualan berhasil dipindahkan.',
                selectedBarn: null,
                selectedPen: null,
                selectedSale: null,
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

  Future<void> _deleteApi(Emitter<SalesItemsState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        final req = SalesItemDeleteRequest(
          sale_id: state.sales.id,
          items: state.selectedItems,
          to_pen_id: (state.selectedPen?.id).toString(),
        );
        final response = await _salesItemDeleteUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                successMessage: 'Item penjualan berhasil dihapus.',
                selectedBarn: null,
                selectedPen: null,
                selectedSale: null,
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

  Future<void> _getSalesApi(SalesList event, Emitter<SalesItemsState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final req = SalesRequest(
          limit: 100,
          id_project: appBloc.state.selectedProject?.id ?? '',
          status: DRAFT,
          page: 1,
        );
        final response = await _salesUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            final errorMessage = data.isEmpty ? 'Data tidak ditemukan' : '';
            final result = data
                .whereNot((item) => item.id == state.sales.id)
                .toList();

            emit(state.copyWith(salesList: result, errorMessage: errorMessage));
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

  Future<void> _getBarnsApi(GetBarns event, Emitter<SalesItemsState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _barnsUseCase.execute(
          BarnRequest(
            projectId: appBloc.state.selectedProject!.id,
            category: 'Penggemukan,Karantina,Isolasi,Penjualan',
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

  Future<void> _getPensApi(GetPens event, Emitter<SalesItemsState> emit) {
    return runBlocCatching(
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _pensUseCase.execute(
          PenRequest(
            barnId: event.barnId,
            projectId: appBloc.state.selectedProject!.id,
            barnCategory: 'Penggemukan,Karantina,Isolasi,Penjualan',
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

  Future<void> _getCattleEarTagApi(
    CheckCattleEarTag event,
    Emitter<SalesItemsState> emit,
  ) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(earTagLoading: true, cattle: null));
        final req = CattleRequest(
          id_project: appBloc.state.selectedProject?.id ?? '',
          eartag: state.earTag,
        );
        final response = await _cattleByEarTagUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(cattle: data, earTagErrorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(earTagErrorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(earTagLoading: false));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(earTagErrorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }
}
