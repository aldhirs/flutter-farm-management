import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/features/account/account/model/account_menu_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_state.freezed.dart';

@freezed
abstract class AccountState extends BaseBlocState with _$AccountState {
  const factory AccountState({
    @Default(UserData()) UserData userData,
    @Default([]) List<AccountMenuItem> menuItems,
    @Default(false) bool logoutBtnLoading,
    @Default('') String packageName,
    @Default(false) bool isShowPopupLogout,
    @Default(0) int notificationCount,
  }) = _AccountState;
  const AccountState._();
}
