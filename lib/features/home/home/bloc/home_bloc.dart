import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/usecases/cattle_by_ear_tag_use_case.dart';
import 'package:farm/features/home/home/bloc/home_event.dart';
import 'package:farm/features/home/home/bloc/home_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  final CattleByEarTagUseCase _cattleByEarTagUseCase;
  HomeBloc(this._cattleByEarTagUseCase) : super(const HomeState()) {
    on<Initiated>(_initialized, transformer: log());
    on<CheckCattleEarTag>(_getCattleEarTagApi, transformer: log());
    on<EarTagChanged>((event, emit) {
      emit(state.copyWith(earTag: event.value, errorMessage: ''));
    }, transformer: log());
    on<ClearData>((event, emit) {
      emit(state.copyWith(earTag: '', cattle: null, errorMessage: ''));
    }, transformer: log());
  }

  Future<void> _initialized(Initiated event, Emitter<HomeState> emit) async {}

  Future<void> _getCattleEarTagApi(
    CheckCattleEarTag event,
    Emitter<HomeState> emit,
  ) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(
          state.copyWith(
            loading: true,
            cattle: null,
            cattleDestination: event.destination,
          ),
        );
        final req = CattleRequest(
          id_project: appBloc.state.selectedProject?.id ?? '',
          eartag: state.earTag,
        );
        final response = await _cattleByEarTagUseCase.execute(req);
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(cattle: data, errorMessage: ''));
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

  bool _isProjectChosen(Emitter<HomeState> emit) {
    if (appBloc.state.selectedProject == null) {
      emit(
        state.copyWith(
          errorMessage: 'Anda harus memilih feedlot terlebih dahulu.',
        ),
      );
      return false;
    }
    return true;
  }
}
