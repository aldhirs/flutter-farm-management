import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/app/bloc/app_state.dart';
import 'package:farm/base/base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppBloc extends BaseBloc<AppEvent, AppState> {
  AppBloc(
    // this._storeAppConfigUseCase,
    // this._getAppConfigUseCase,
    // this._updateFcmTokenUseCase,
    // TODO
    // this._saveIsDarkModeUseCase,
    // this._saveLanguageCodeUseCase,
  ) : super(const AppState()) {
    on<AppInitiated>(_onAppInitiated, transformer: log());
    on<IsLoggedInStatusChanged>(_onIsLoggedInStatusChanged, transformer: log());
    on<AppThemeChanged>(_onAppThemeChanged, transformer: throttleTime());
  }

  // final StoreAppConfigUseCase _storeAppConfigUseCase;
  // final GetAppConfigUseCase _getAppConfigUseCase;
  // final UpdateFcmTokenUseCase _updateFcmTokenUseCase;
  // TODO
  // final SaveIsDarkModeUseCase _saveIsDarkModeUseCase;
  // final SaveLanguageCodeUseCase _saveLanguageCodeUseCase;

  void _onIsLoggedInStatusChanged(
    IsLoggedInStatusChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(isLoggedIn: event.isLoggedIn));
  }

  Future<void> _onAppThemeChanged(
    AppThemeChanged event,
    Emitter<AppState> emit,
  ) async {
    await runBlocCatching(
      action: () async {
        // TODO
        // await _saveIsDarkModeUseCase
        //     .execute(SaveIsDarkModeInput(isDarkMode: event.isDarkTheme));
        // _updateThemeSetting(event.isDarkTheme);
        // emit(state.copyWith(isDarkTheme: event.isDarkTheme));
      },
    );
  }

  // Future<void> _onUpdateFcmToken(
  //   OnUpdateFcmToken event,
  //   Emitter<AppState> emit,
  // ) async {
  //   await runBlocCatching(
  //     action: () async {
  //       emit(state.copyWith(fcmToken: event.token));
  //       await _updateFcmTokenUseCase.execute(
  //         FcmTokenRequest(token: event.token),
  //       );
  //     },
  //   );
  // }

  // Future<void> _onAppLanguageChanged(
  //   AppLanguageChanged event,
  //   Emitter<AppState> emit,
  // ) async {
  //   await runBlocCatching(
  //     action: () async {
  //       // TODO
  //       // await _saveLanguageCodeUseCase
  //       //     .execute(SaveLanguageCodeInput(languageCode: event.languageCode));
  //       emit(state.copyWith(languageCode: event.languageCode));
  //     },
  //   );
  // }

  Future<void> _onAppInitiated(
    AppInitiated event,
    Emitter<AppState> emit,
  ) async {
    // final appConfig = switch (runCatching(
    //   action: () => _getAppConfigUseCase.execute(const GetAppConfigInput()),
    // )) {
    //   ResultSuccess(:final data) => data.data,
    //   _ => const AppConfig(),
    // };

    //   emit(state.copyWith(appConfig: appConfig));
  }

  // Future<void> _storeAppConfig(Emitter<AppState> emit) async {
  //   await runBlocCatching(
  //     handleLoading: false,
  //     action: () async {
  //       await _storeAppConfigUseCase.execute(const StoreAppConfigInput());
  //       // TODO
  //       // final output =
  //       //     _getInitialAppDataUseCase.execute(const GetInitialAppDataInput());
  //       // _updateThemeSetting(output.isDarkMode);
  //       // emit(state.copyWith(
  //       //   isDarkTheme: output.isDarkMode,
  //       //   isLoggedIn: output.isLoggedIn,
  //       //   languageCode: output.languageCode,
  //       // ));
  //     },
  //   );
  // }

  // void _updateThemeSetting(bool isDarkTheme) {
  //   AppThemeSetting.currentAppThemeType = isDarkTheme
  //       ? AppThemeType.dark
  //       : AppThemeType.light;
  // }
}
