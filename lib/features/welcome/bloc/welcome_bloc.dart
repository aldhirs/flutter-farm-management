import 'package:farm/base/base.dart';
import 'package:farm/features/welcome/bloc/welcome_event.dart';
import 'package:farm/features/welcome/bloc/welcome_state.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class WelcomeBloc extends BaseBloc<WelcomeEvent, WelcomeState> {
  // final SaveIsFirstLaunchAppUseCase _saveIsFirstLaunchAppUseCase;
  // WelcomeBloc(this._saveIsFirstLaunchAppUseCase) : super(const WelcomeState()) {
  WelcomeBloc() : super(const WelcomeState()) {
    on<Initiated>(_initialized, transformer: log());
    on<LoginPressed>(_loginPressed, transformer: log());
    on<RegisterPressed>(_registerPressed, transformer: log());
  }

  Future<void> _initialized(Initiated event, Emitter<WelcomeState> emit) async {
    // await _saveIsFirstLaunchAppUseCase.execute(
    //   const SaveIsFirstLaunchAppInput(isFirstLaunchApp: true),
    // );
  }

  Future<void> _loginPressed(
    LoginPressed event,
    Emitter<WelcomeState> emit,
  ) async {
    await navigator.push(const AppRouteInfo.login());
  }

  Future<void> _registerPressed(
    RegisterPressed event,
    Emitter<WelcomeState> emit,
  ) async {
    // await navigator.showDialog(
    //   AppPopupInfo.confirmDialog(
    //     title: S.current.coming_soon,
    //     message: S.current.coming_soon,
    //   ),
    // );
    // await navigator.push(const AppRouteInfo.login());
  }
}
