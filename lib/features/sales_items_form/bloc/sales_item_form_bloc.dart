import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/cattle/cattle_list_request.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/sales/sales_item_save_request.dart';
import 'package:farm/domain/usecases/barns_use_case.dart';
import 'package:farm/domain/usecases/cattles_use_case.dart';
import 'package:farm/domain/usecases/pens_use_case.dart';
import 'package:farm/domain/usecases/sales_item_save_use_case.dart';
import 'package:farm/features/sales_items_form/bloc/sales_item_form_event.dart';
import 'package:farm/features/sales_items_form/bloc/sales_item_form_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SalesItemFormBloc
    extends BaseBloc<SalesItemFormEvent, SalesItemFormState> {
  final BarnsUseCase _barnsUseCase;
  final CattlesUseCase _cattleUseCase;
  final PensUseCase _pensUseCase;
  final SalesItemSaveUseCase _salesItemSaveUseCase;
  final limit = 8;
  SalesItemFormBloc(
    this._barnsUseCase,
    this._pensUseCase,
    this._cattleUseCase,
    this._salesItemSaveUseCase,
  ) : super(const SalesItemFormState()) {
    on<Initiated>(_initialized, transformer: log());
    on<Load>(_load, transformer: log());
    on<LoadMore>(_loadMore, transformer: log());
    on<GetPens>(_getPensApi, transformer: log());
    on<OnSubmit>(_onSubmit, transformer: log());
    on<SelectedItemChanged>(_onSelectedItem, transformer: log());
    on<BarnChanged>((event, emit) {
      emit(state.copyWith(selectedBarn: event.barn, selectedPen: null));
      add(GetPens(barnId: event.barn.id));
    }, transformer: log());
    on<PenChanged>((event, emit) {
      emit(state.copyWith(selectedPen: event.pen));
    }, transformer: log());
    on<OnClearMessage>((event, emit) {
      emit(state.copyWith(errorMessage: ''));
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<SalesItemFormState> emit,
  ) async {
    emit(state.copyWith(sales: event.item));
    await _barnsApi(emit);
  }

  Future<void> _load(Load event, Emitter<SalesItemFormState> emit) async {
    await _loadApi(emit, 1, false);
  }

  Future<void> _loadMore(
    LoadMore event,
    Emitter<SalesItemFormState> emit,
  ) async {
    if (state.isLoadMore || !state.hasMore) return;
    emit(state.copyWith(isLoadMore: true));
    final nextPage = (state.items.length ~/ limit) + 1;
    await _loadApi(emit, nextPage, true);
  }

  Future<void> _loadApi(
    Emitter<SalesItemFormState> emit,
    int nextPage,
    bool isLoadMore,
  ) {
    return runBlocCatching(
      handleLoading: !state.isLoadMore,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final req = CattleListRequest(
          limit: limit,
          id_pen: (state.selectedPen?.id).orEmpty(),
          page: nextPage,
          status: 'available',
        );
        final response = await _cattleUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            var items = data;
            if (isLoadMore) {
              items = [...state.items, ...data];
            }
            emit(
              state.copyWith(
                items: items,
                selectedItems: [],
                errorSnackMessage: '',
                errorMessage: items.isEmpty
                    ? 'Data tidak ditemukan, silakan untuk pilih kembali'
                    : '',
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

  Future<void> _barnsApi(Emitter<SalesItemFormState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _barnsUseCase.execute(
          BarnRequest(
            projectId: appBloc.state.selectedProject!.id,
            category: 'Penggemukan',
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(barns: data, errorMessage: '', selectedItems: []),
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

  Future<void> _onSelectedItem(
    SelectedItemChanged event,
    Emitter<SalesItemFormState> emit,
  ) async {
    var items = state.selectedItems;
    final exists = state.selectedItems.any((e) => e.id == event.cattle.id);
    if (exists) {
      items = state.selectedItems
          .where((e) => e.id != event.cattle.id)
          .toList();
    } else {
      items = [...items, event.cattle];
    }
    emit(state.copyWith(selectedItems: items));
  }

  Future<void> _onSubmit(
    OnSubmit event,
    Emitter<SalesItemFormState> emit,
  ) async {
    if (state.selectedItems.isEmpty) {
      emit(
        state.copyWith(
          errorSnackMessage: 'Pilih minimal 1 sapi terlebih dahulu',
        ),
      );
      return;
    }

    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final cattles = state.selectedItems.map((p) => p.id).toList();
        final response = await _salesItemSaveUseCase.execute(
          SalesItemSaveRequest(id_sale: state.sales.id, id_cattles: cattles),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                isSuccessSave: true,
                errorMessage: '',
                selectedItems: [],
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

  Future<void> _getPensApi(GetPens event, Emitter<SalesItemFormState> emit) {
    return runBlocCatching(
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _pensUseCase.execute(
          PenRequest(
            barnId: event.barnId,
            projectId: appBloc.state.selectedProject!.id,
            barnCategory: 'Penggemukan',
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

  bool _isProjectChosen(Emitter<SalesItemFormState> emit) {
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
