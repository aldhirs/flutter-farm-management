import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_event.freezed.dart';

abstract class AppEvent extends BaseBlocEvent {
  const AppEvent();
}

@freezed
abstract class IsLoggedInStatusChanged extends AppEvent
    with _$IsLoggedInStatusChanged {
  const factory IsLoggedInStatusChanged({required bool isLoggedIn}) =
      _IsLoggedInStatusChanged;
  const IsLoggedInStatusChanged._();
}

@freezed
abstract class GetProjects extends AppEvent with _$GetProjects {
  const factory GetProjects({required bool showProject}) = _GetProjects;
  const GetProjects._();
}

@freezed
abstract class ShowProjects extends AppEvent with _$ShowProjects {
  const factory ShowProjects() = _ShowProjects;
  const ShowProjects._();
}

@freezed
abstract class DismissProjects extends AppEvent with _$DismissProjects {
  const factory DismissProjects() = _DismissProjects;
  const DismissProjects._();
}

@freezed
abstract class SelectedProject extends AppEvent with _$SelectedProject {
  const factory SelectedProject({Project? project}) = _SelectedProject;
  const SelectedProject._();
}

@freezed
abstract class AppThemeChanged extends AppEvent with _$AppThemeChanged {
  const factory AppThemeChanged({required bool isDarkTheme}) = _AppThemeChanged;
  const AppThemeChanged._();
}

@freezed
abstract class OnUpdateFcmToken extends AppEvent with _$OnUpdateFcmToken {
  const factory OnUpdateFcmToken({required String token}) = _OnUpdateFcmToken;
  const OnUpdateFcmToken._();
}

@freezed
abstract class AppInitiated extends AppEvent with _$AppInitiated {
  const factory AppInitiated() = _AppInitiated;
  const AppInitiated._();
}

@freezed
abstract class Clear extends AppEvent with _$Clear {
  const factory Clear() = _Clear;
  const Clear._();
}
