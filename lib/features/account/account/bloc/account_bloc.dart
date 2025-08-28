import 'package:farm/base/base.dart';
import 'package:farm/features/account/account/bloc/account_event.dart';
import 'package:farm/features/account/account/bloc/account_state.dart';
import 'package:farm/features/account/account/model/account_menu_item.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AccountBloc extends BaseBloc<AccountEvent, AccountState> {
  // final MeUseCase _meUseCase;
  // final GetUserDataUseCase _getUserDataUseCase;
  // final GetAppConfigUseCase _getAppConfigUseCase;
  // final LogoutUseCase _logoutUseCase;

  // AccountBloc(
  //   this._meUseCase,
  //   this._getUserDataUseCase,
  //   this._logoutUseCase,
  //   this._getAppConfigUseCase,
  // ) : super(const AccountState()) {
  AccountBloc(
    // this._meUseCase,
    // this._getUserDataUseCase,
    // this._logoutUseCase,
    // this._getAppConfigUseCase,
  ) : super(const AccountState()) {
    on<Initiated>(_initialized, transformer: log());
    on<ClearPopupConfirmation>(_clearPopupConfirmation, transformer: log());
    on<LogoutPressed>(_logoutPressed, transformer: log());
    on<InboxPressed>(_inboxPressed, transformer: log());
    on<OnLogoutConfirmPressed>(_onLogoutConfirmPressed, transformer: log());
    on<OnNotificationCount>(_onNotificationCount, transformer: log());
  }

  Future<void> _initialized(Initiated event, Emitter<AccountState> emit) async {
    // final user = switch (runCatching(
    //   action: () => _getUserDataUseCase.execute(const GetUserDataInput()),
    // )) {
    //   ResultSuccess(:final data) => data,
    //   _ => const UserData(),
    // };

    // final appConfig = switch (runCatching(
    //   action: () => _getAppConfigUseCase.execute(const GetAppConfigInput()),
    // )) {
    //   ResultSuccess(:final data) => data.data,
    //   _ => const AppConfig(),
    // };

    emit(
      state.copyWith(
        // packageName: event.packageName.defaultValue(''),
        // userData: user,
        menuItems: [
          AccountMenuItem(
            name: 'Edit Profil',
            icon: const Icon(Icons.account_box),
            section: 1,
            action: () {},
          ),
          AccountMenuItem(
            name: 'Keluar',
            icon: const Icon(Icons.logout),
            action: () {
              add(const LogoutPressed());
            },
            section: 2,
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

  Future<void> _inboxPressed(
    InboxPressed event,
    Emitter<AccountState> emit,
  ) async {
    // await navigator.pushRoute(const InboxRoute());
  }

  Future<void> _onLogoutConfirmPressed(
    OnLogoutConfirmPressed event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(logoutBtnLoading: true));
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        // await _logoutUseCase.execute(
        //   LogoutRequest(email: state.userData.email),
        // );
      },
      doOnEventCompleted: () async {
        navigator.pushAndPopUntil(const AppRouteInfo.welcome());
      },
    );
  }

  Future<void> _onMeApi(Emitter<AccountState> emit) async {
    // return runBlocCatching(
    //   handleLoading: false,
    //   action: () async {
    //     final response = await _meUseCase.execute(const MeRequest(refresh: 0));
    //     switch (response.result) {
    //       case DataSuccess(:final data):
    //         emit(state.copyWith(userData: data));
    //         break;
    //       case DataError():
    //         break;
    //       case null:
    //         return;
    //     }
    //   },
    //   doOnEventCompleted: () async {},
    // );
  }

  Future<void> _onNotificationCount(
    OnNotificationCount event,
    Emitter<AccountState> emit,
  ) async {
    // final docPath = UrlConstants.fsInboxCollectionPath('');
    // _firestore = FirebaseFirestore.instance;
    // final docRef = _firestore?.collection(docPath).doc(state.userData.username);
    // final snapshot = await docRef?.get();
    // if (snapshot != null && snapshot.exists) {
    //   final jsonData = snapshot.data();
    //   emit(state.copyWith(notificationCount: jsonData?["unread"] ?? 0));
    // }
  }
}
