import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/account/account/bloc/account_bloc.dart';
import 'package:farm/features/account/account/bloc/account_event.dart';
import 'package:farm/features/account/account/bloc/account_state.dart';
import 'package:farm/features/account/account/widgets/avatar_widget.dart';
import 'package:farm/features/account/account/widgets/list_item_widget.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends BasePageState<AccountPage, AccountBloc> {
  TabsRouter? tabsRouter;

  @override
  void initState() {
    super.initState();
    _init();
    tabsRouter = context.tabsRouter;
    tabsRouter?.addListener(_tabRouterListener);
  }

  void _init() {
    bloc.add(const Initiated(null));
    // bloc.add(const OnNotificationCount());
  }

  void _tabRouterListener() {
    if (tabsRouter?.activeIndex == 1) {
      _init();
    }
  }

  @override
  void dispose() {
    if (mounted) {
      tabsRouter?.removeListener(_tabRouterListener);
    }
    super.dispose();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountBloc, AccountState>(
          listenWhen: (previous, current) =>
              previous.isShowPopupLogout != current.isShowPopupLogout,
          listener: (context, state) {
            if (state.isShowPopupLogout) {
              showDialog(
                useRootNavigator: false,
                barrierDismissible: false,
                context: context,
                builder: (builder) => _popupConfirmationLogout(),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }

  Widget _popupConfirmationLogout() {
    return Stack(
      children: [
        Popup(
          title: 'Keluar Aplikasi?',
          description: [
            TextSpan(text: 'Apakah Anda ingin keluar dari aplikasi?'),
          ],
          positiveButtonText: 'Batalkan',
          negativeButtonText: 'Ya, Keluar',
          onPositiveButtonPressed: () {
            navigator.pop();
            bloc.add(const ClearPopupConfirmation());
          },
          onNegativeButtonPressed: () {
            bloc.add(const OnLogoutConfirmPressed());
          },
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return CommonScaffold(
          appBar: CommonAppBar(
            automaticallyImplyLeading: false,
            titleSpacing: NavigationToolbar.kMiddleSpacing,
            backgroundColor: Colors.transparent,
            title: Text('Akun', style: TextStyles.heading6()),
          ),
          body: Container(
            height: ViewUtils.screenHeight(),
            color: AppColors.current.neutral400,
            padding: const EdgeInsets.only(bottom: Dimens.d24),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  _avatar(),
                  const SizedBox(height: Dimens.d8),
                  _listFirstMenuItems(),
                  const SizedBox(height: Dimens.d8),
                  _listSecondMenuItems(),
                  const SizedBox(height: Dimens.d20),
                  Center(
                    child: Text(
                      'Keamanan',
                      style: TextStyles.body2().copyWith(
                        color: AppColors.current.text300,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimens.d8),
                  Center(child: Text('v1.0.0', style: TextStyles.paragraph3())),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BlocBuilder<AccountBloc, AccountState> _listFirstMenuItems() {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) => previous.menuItems != current.menuItems,
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.current.neutral500),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(Dimens.d8),
            itemCount: state.menuItems
                .where((item) => item.section == 1)
                .length,
            itemBuilder: (BuildContext context, int index) {
              var firstSectionMenu = state.menuItems
                  .where((item) => item.section == 1)
                  .toList();
              return ListItemWidget(menuItem: firstSectionMenu[index]);
            },
          ),
        );
      },
    );
  }

  BlocBuilder<AccountBloc, AccountState> _listSecondMenuItems() {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.current.neutral500),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(Dimens.d8),
            itemCount: state.menuItems
                .where((item) => item.section == 2)
                .length,
            itemBuilder: (BuildContext context, int index) {
              var secondSectionMenu = state.menuItems
                  .where((item) => item.section == 2)
                  .toList();
              return ListItemWidget(menuItem: secondSectionMenu[index]);
            },
          ),
        );
      },
    );
  }

  Widget _avatar() {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              // navigator.pushRoute(
              //   AccountSettingRoute(userType: state.userData.professionName),
              // );
            },
            child: Row(
              children: [
                AvatarWidget(avatarUrl: ''),
                const SizedBox(width: Dimens.d8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hend',
                      // state.userData.name,
                      style: TextStyles.button3().copyWith(
                        color: AppColors.current.royalNavy900,
                      ),
                    ),
                    // TagCategory(
                    //   text: state.userData.displayProfessionName,
                    //   type: TagCategoryType.royalNavy,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
