import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/project/discover_summary_request.dart';
import 'package:farm/domain/usecases/cattle_by_ear_tag_use_case.dart';
import 'package:farm/domain/usecases/discover_summary_use_case.dart';
import 'package:farm/features/home/home/bloc/home_event.dart';
import 'package:farm/features/home/home/bloc/home_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  final CattleByEarTagUseCase _cattleByEarTagUseCase;
  final DiscoverSummaryUseCase _discoverSummaryUseCase;
  HomeBloc(this._cattleByEarTagUseCase, this._discoverSummaryUseCase)
    : super(const HomeState()) {
    on<Initiated>(_initialized, transformer: log());
    on<Refreshed>(_refreshed, transformer: log());
    on<CheckCattleEarTag>(_getCattleEarTagApi, transformer: log());
    on<EarTagChanged>((event, emit) {
      emit(state.copyWith(earTag: event.value, errorMessage: ''));
    }, transformer: log());
    on<ClearData>((event, emit) {
      emit(state.copyWith(earTag: '', cattle: null, errorMessage: ''));
    }, transformer: log());
  }

  /// Pemuatan saat halaman dibuka.
  Future<void> _initialized(Initiated event, Emitter<HomeState> emit) {
    return _loadDiscoverSummary(emit);
  }

  /// Pemuatan yang sama, tetapi pemanggilnya menunggu.
  ///
  /// Completer diselesaikan di `finally`, sehingga indikator tetap berhenti
  /// berputar meski pemuatan gagal. Indikator yang berputar selamanya setelah
  /// permintaan gagal terbaca sebagai aplikasi menggantung, bukan sebagai
  /// kegagalan — dan pengguna akan menariknya lagi, bukan memeriksa jaringannya.
  ///
  /// Dijaga agar hanya diselesaikan sekali: menyelesaikan Completer dua kali
  /// melempar, dan itu akan terjadi tepat pada tarikan kedua yang menyusul
  /// tarikan pertama yang belum selesai.
  Future<void> _refreshed(Refreshed event, Emitter<HomeState> emit) async {
    try {
      await _loadDiscoverSummary(emit);
    } finally {
      final completer = event.completer;
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
    }
  }

  /// Memuat empat angka Discover untuk feedlot yang sedang dipilih.
  ///
  /// Tanpa feedlot, angka-angka itu tidak dimuat sama sekali dan yang sudah ada
  /// dibuang. Alasannya bukan sekadar menghemat permintaan: server menolak
  /// hitungan tanpa feedlot, dan menahan angka feedlot sebelumnya di layar
  /// setelah pengguna keluar dari feedlot itu akan menampilkan pekerjaan yang
  /// bukan miliknya lagi.
  ///
  /// Kegagalan tidak memunculkan pesan error. Discover adalah ringkasan sekilas
  /// di beranda, bukan hasil dari sesuatu yang diminta pengguna; menyela
  /// beranda dengan dialog karena empat angka gagal dimuat lebih mengganggu
  /// daripada menampilkan tanda hubung.
  Future<void> _loadDiscoverSummary(Emitter<HomeState> emit) async {
    final project = appBloc.state.selectedProject;
    if (project == null || project.id.isEmpty) {
      emit(state.copyWith(discoverSummary: null, discoverLoading: false));
      return;
    }

    return runBlocCatching(
      handleLoading: false,
      handleError: false,
      action: () async {
        emit(state.copyWith(discoverLoading: true));
        final response = await _discoverSummaryUseCase.execute(
          DiscoverSummaryRequest(
            clientSlug: appBloc.state.userData?.clientSlug ?? '',
            project: project.id,
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(discoverSummary: data));
          case DataError():
            emit(state.copyWith(discoverSummary: null));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(discoverLoading: false));
      },
      doOnError: (e) async {
        emit(state.copyWith(discoverSummary: null, discoverLoading: false));
      },
    );
  }

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
