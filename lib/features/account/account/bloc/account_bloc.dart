import 'package:dartx/dartx.dart';
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
        feedlotName: (appBloc.state.selectedProject?.name).orEmpty(),
        menuItems: [
          AccountMenuItem(
            name: 'Ubah Kata Sandi',
            description: 'Ganti kata sandi yang dipakai untuk masuk',
            icon: const Icon(Icons.lock_outline),

            /// Kabar berhasil diberikan di sini, bukan di halaman formulir.
            ///
            /// Halaman itu menutup dirinya sendiri begitu server menerima, jadi
            /// pesan apa pun yang ia tampilkan akan ikut hilang pada detik yang
            /// sama. Layar yang masih berdirilah yang bisa mengabarkannya.
            action: () async {
              final changed = await navigator.push<bool>(
                const AppRouteInfo.changePassword(),
              );
              if (changed == true) {
                navigator.showSuccessSnackBar('Kata sandi berhasil diubah.');
              }
            },
            section: 0,
          ),
          AccountMenuItem(
            name: 'Keluar',
            description: 'Akhiri sesi di perangkat ini',
            icon: const Icon(Icons.logout),
            action: () {
              add(const LogoutPressed());
            },
            section: 1,
            isDestructive: true,
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
