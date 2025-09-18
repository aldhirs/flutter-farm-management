import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/usecases/cattle_by_ear_tag_use_case.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_event.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_state.dart';
import 'package:farm/features/cattle/search/model/list_item.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CattleSearchBloc extends BaseBloc<CattleSearchEvent, CattleSearchState> {
  final CattleByEarTagUseCase _cattleByEarTagUseCase;
  CattleSearchBloc(this._cattleByEarTagUseCase)
    : super(const CattleSearchState()) {
    on<Initiated>(_initialized, transformer: log());
    on<CheckCattleEarTag>(_getCattleEarTagApi, transformer: log());
    on<EarTagChanged>((event, emit) {
      emit(state.copyWith(earTag: event.value, errorMessage: ''));
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<CattleSearchState> emit,
  ) async {}

  Future<void> _getCattleEarTagApi(
    CheckCattleEarTag event,
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
          eartag: state.earTag,
        );
        final response = await _cattleByEarTagUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                cattle: data,
                listItems: _getCattleItems(data),
                errorMessage: '',
              ),
            );
            break;
          case DataError(:final errorMessage):
            emit(
              state.copyWith(
                cattle: null,
                listItems: [],
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

  List<ListItem> _getCattleItems(Cattle data) {
    final items = [
      ListItem(name: 'ID', description: data.id),
      ListItem(name: 'RFID', description: data.rfid_tag),
      ListItem(name: 'Kandang', description: data.pen?.name_barn ?? '-'),
      ListItem(name: 'Pen', description: data.pen?.name ?? '-'),
      ListItem(name: 'Ear Tag', description: data.ear_tag),
      ListItem(
        name: 'Bobot',
        description: '${data.actual_weight.toString()} Kg',
      ),
      ListItem(name: 'Ras', description: data.id_breed),
      ListItem(name: 'Jenis Kelamin', description: data.genderLabel()),
      ListItem(name: 'Status', description: data.statusLabel()),
    ];
    return items;
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
