import 'package:dartx/dartx.dart';
import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/app/bloc/app_state.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:farm/domain/entities/project/project_request.dart';
import 'package:farm/domain/repositories/source/source.dart';
import 'package:farm/domain/usecases/get_user_data_use_case.dart';
import 'package:farm/domain/usecases/projects_use_case.dart';
import 'package:farm/helper/run_catching/result.dart';
import 'package:farm/helper/run_catching/run_catching.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppBloc extends BaseBloc<AppEvent, AppState> {
  AppBloc(this._projectsUseCase, this._userDataUseCase, this._appPreferences)
    : super(const AppState()) {
    on<AppInitiated>(_onAppInitiated, transformer: log());
    on<IsLoggedInStatusChanged>(_onIsLoggedInStatusChanged, transformer: log());
    on<GetProjects>(_getProjects, transformer: log());
    on<SelectedProject>(_selectedProject, transformer: log());
    on<ShowProjects>((event, emit) async {
      if (state.projects.isEmpty) {
        add(const GetProjects());
      } else {
        emit(state.copyWith(showProjects: true));
      }
    }, transformer: log());
    on<DismissProjects>((event, emit) async {
      emit(state.copyWith(showProjects: false));
    }, transformer: log());
  }

  final ProjectsUseCase _projectsUseCase;
  final GetUserDataUseCase _userDataUseCase;
  final AppPreferences _appPreferences;

  Future<void> _onAppInitiated(
    AppInitiated event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedProject: _appPreferences.project,
        showProjects: false,
      ),
    );
  }

  Future<void> _selectedProject(
    SelectedProject event,
    Emitter<AppState> emit,
  ) async {
    _appPreferences.saveProject(event.project ?? const Project());
    emit(state.copyWith(selectedProject: event.project, showProjects: false));
  }

  void _onIsLoggedInStatusChanged(
    IsLoggedInStatusChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(isLoggedIn: event.isLoggedIn));
  }

  Future<void> _userData(Emitter<AppState> emit) async {
    // user data
    final user = switch (runCatching(
      action: () => _userDataUseCase.execute(const GetUserDataInput()),
    )) {
      ResultSuccess(:final data) => data,
      _ => const UserData(),
    };
    emit(state.copyWith(userData: user));
  }

  Future<void> _getProjects(GetProjects event, Emitter<AppState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        await _userData(emit);

        if (state.userData != null) {
          final response = await _projectsUseCase.execute(
            ProjectRequest(clientSlug: state.userData!.clientSlug.orEmpty()),
          );
          switch (response.result) {
            case DataSuccess(:final data):
              emit(state.copyWith(projects: data, showProjects: true));
              break;
            case DataError(:final errorMessage):
              navigator.showErrorSnackBar(errorMessage.orEmpty());
            case null:
              return;
          }
        }
      },
      doOnEventCompleted: () async {},
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(showProjects: false));
        navigator.showErrorSnackBar(exceptionMessageMapper.map(e));
      },
    );
  }
}
