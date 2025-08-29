import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/login_request.dart';
import 'package:farm/domain/usecases/login_use_case.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/auth/login/bloc/login_event.dart';
import 'package:farm/features/auth/login/bloc/login_state.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  // final LogoutUseCase _logoutUseCase;
  // final ForgotPasswordUseCase _forgotPasswordUseCase;
  // final UpdateFcmTokenUseCase _updateFcmTokenUseCase;

  LoginBloc(
    this._loginUseCase,
    // this._logoutUseCase,
    // this._forgotPasswordUseCase,
    // this._updateFcmTokenUseCase,
  ) : super(const LoginState()) {
    on<Initiated>(_initialized, transformer: log());
    on<OnLoginPressed>(_onLoginPressed, transformer: log());
    on<OnInputEmailChanged>(_onInputEmailChanged, transformer: log());
    on<OnInputPasswordChanged>(_onInputPasswordChanged, transformer: log());
    on<ClearError>(_onClearError, transformer: log());
    on<InitForgotPassword>(_initForgotPassword, transformer: log());
    on<ForgotPasswordPressed>(_forgotPasswordPressed, transformer: log());
  }

  Future<void> _initialized(Initiated event, Emitter<LoginState> emit) async {
    _logout();
    emit(
      state.copyWith(
        fcmToken: event.fcmToken.orEmpty(),
        // messageChangePassword: event.messageChangePassword.defaultValue(''),
      ),
    );
  }

  void _logout() {
    // final _ = switch (runCatching(
    //   action: () => _logoutUseCase.execute(const LogoutRequest()),
    // )) {
    //   ResultSuccess(:final data) => data,
    //   _ => {},
    // };
  }

  bool isLoginButtonVisible() {
    return state.email.isNotEmpty && state.password.isNotEmpty;
  }

  Future<void> _onClearError(ClearError event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        respError: null,
        loginInvalid: false,
        // connectionProblemMessage: "",
      ),
    );
  }

  FutureOr<void> _onLoginPressed(
    OnLoginPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isButtonLoginPressed: true, loginInvalid: false));
    if (state.emailValid && state.password.isNotEmpty) {
      return _loginApi(emit);
    } else {
      emit(state.copyWith(isButtonLoginPressed: false, loginInvalid: true));
    }
  }

  void _onInputEmailChanged(
    OnInputEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    add(const ClearError());
    emit(
      state.copyWith(
        email: event.email,
        emailValid: event.email.isValidEmail(),
        isButtonVisible: _isButtonVisible(event.email, state.password),
      ),
    );
  }

  bool _isButtonVisible(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty;
  }

  void _onInputPasswordChanged(
    OnInputPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    add(const ClearError());
    emit(
      state.copyWith(
        password: event.password,
        isButtonVisible: _isButtonVisible(state.email, event.password),
      ),
    );
  }

  Future<void> _loginApi(Emitter<LoginState> emit) {
    return runBlocCatching(
      action: () async {
        final response = await _loginUseCase.execute(
          LoginRequest(email: state.email, password: state.password),
        );
        switch (response.result) {
          case DataSuccess():
            await _onUpdateFcmToken(emit);
            await navigator.replaceAll([const AppRouteInfo.home()]);
            break;

          case DataError(:final errorMessage):
            emit(state.copyWith(respError: errorMessage, loginInvalid: true));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        await _onClearButtonPressed(emit);
      },
      handleError: false,
      doOnError: (e) async {
        emit(
          state.copyWith(
            respError: exceptionMessageMapper.map(e),
            loginInvalid: true,
          ),
        );
      },
    );
  }

  Future<void> _onClearButtonPressed(Emitter<LoginState> emit) async {
    emit(state.copyWith(isButtonLoginPressed: false));
  }

  Future<void> _initForgotPassword(
    InitForgotPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith());
  }

  Future<void> _forgotPasswordPressed(
    ForgotPasswordPressed event,
    Emitter<LoginState> emit,
  ) async {}

  Future<void> _onUpdateFcmToken(Emitter<LoginState> emit) async {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        // await _updateFcmTokenUseCase.execute(
        //   FcmTokenRequest(token: state.fcmToken),
        // );
      },
    );
  }
}
