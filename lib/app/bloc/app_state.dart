import 'package:farm/base/base.dart';
import 'package:farm/config/app_config.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState extends BaseBlocState with _$AppState {
  const factory AppState({
    @Default(false) bool isLoggedIn,
    @Default(false) bool isDarkTheme,
    @Default('') String fcmToken,
    @Default([]) List<Project> projects,
    @Default(null) Project? selectedProject,
    @Default(null) UserData? userData,
    @Default(false) bool showProjects,
  }) = _AppState;
  const AppState._();
}
