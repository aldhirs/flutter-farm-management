import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/usecases/get_user_data_use_case.dart';
import 'package:farm/domain/usecases/logout_use_case.dart';
import 'package:farm/features/account/account/bloc/account_event.dart';
import 'package:farm/features/account/account/bloc/account_state.dart';
import 'package:farm/features/account/account/model/account_menu_item.dart';
import 'package:farm/helper/run_catching/result.dart';
import 'package:farm/helper/run_catching/run_catching.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AccountBloc extends BaseBloc<AccountEvent, AccountState> {
  final GetUserDataUseCase _getUserDataUseCase;
  final LogoutUseCase _logoutUseCase;

  AccountBloc(this._getUserDataUseCase, this._logoutUseCase)
    : super(const AccountState()) {
    on<Initiated>(_initialized, transformer: log());
    on<ClearPopupConfirmation>(_clearPopupConfirmation, transformer: log());
    on<LogoutPressed>(_logoutPressed, transformer: log());
    on<OnLogoutConfirmPressed>(_onLogoutConfirmPressed, transformer: log());
  }

  Future<void> _initialized(Initiated event, Emitter<AccountState> emit) async {
    final user = switch (runCatching(
      action: () => _getUserDataUseCase.execute(const GetUserDataInput()),
    )) {
      ResultSuccess(:final data) => data,
      _ => const UserData(),
    };
    emit(
      state.copyWith(
        userData: user,
        menuItems: [
          // AccountMenuItem(
          //   name: 'Edit Profil',
          //   icon: const Icon(Icons.account_box),
          //   section: 1,
          //   action: () {},
          // ),
          AccountMenuItem(
            name: 'Keluar',
            icon: const Icon(Icons.logout),
            action: () {
              add(const LogoutPressed());
            },
            section: 1,
          ),
        ],
      ),
    );
    // await _onMeApi(emit);
  }

  Future<void> _clearPopupConfirmation(
    ClearPopupConfirmation event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isShowPopupLogout: false));
  }

  Future<void> _logoutPressed(
    LogoutPressed event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isShowPopupLogout: true));
  }

  Future<void> _onLogoutConfirmPressed(
    OnLogoutConfirmPressed event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(logoutBtnLoading: true));
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        await _logoutUseCase.execute(const LogoutInput());
      },
      doOnEventCompleted: () async {
        navigator.pushAndPopUntil(const AppRouteInfo.welcome());
      },
    );
  }
}
