import 'package:auto_route/auto_route.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/env_constants.dart';
import 'package:farm/features/account/account/bloc/account_bloc.dart';
import 'package:farm/features/account/account/bloc/account_event.dart';
import 'package:farm/features/account/account/bloc/account_state.dart';
import 'package:farm/features/account/account/model/account_menu_item.dart';
import 'package:farm/features/account/account/widgets/avatar_widget.dart';
import 'package:farm/features/account/account/widgets/list_item_widget.dart';
import 'package:farm/resources/resource.dart';
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
    return CommonScaffold(
      backgroundColor: AppColors.current.neutral400,
      appBar: CommonAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        backgroundColor: Colors.transparent,
        title: Text('Akun', style: TextStyles.heading6()),
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        bloc: bloc,
        builder: (context, state) {
          /// Menu dipisah menurut akibatnya, bukan menurut urutan datangnya.
          ///
          /// Yang mengubah pengaturan berkumpul di satu kartu; yang mengakhiri
          /// sesi berdiri sendiri, terpisah jarak, sehingga tidak bisa tertekan
          /// hanya karena ibu jari meleset satu baris.
          final settings = state.menuItems
              .where((item) => !item.isDestructive)
              .toList();
          final destructive = state.menuItems
              .where((item) => item.isDestructive)
              .toList();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              Dimens.d16,
              Dimens.d8,
              Dimens.d16,
              Dimens.d32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _profileCard(state),
                const SizedBox(height: Dimens.d24),
                if (settings.isNotEmpty) ...[
                  _sectionLabel('Pengaturan Akun'),
                  const SizedBox(height: Dimens.d8),
                  _menuCard(settings),
                  const SizedBox(height: Dimens.d24),
                ],
                if (destructive.isNotEmpty) _menuCard(destructive),
                const SizedBox(height: Dimens.d28),
                _footer(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyles.label2().copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.current.neutral600,
      ),
    );
  }

  /// Kartu pengenal: siapa yang masuk, dan di kebun mana.
  ///
  /// Dua keterangan itu yang dicari orang ketika membuka tab ini — biasanya
  /// setelah ponsel berpindah tangan di kandang, untuk memastikan ia tidak
  /// sedang mencatat atas nama rekannya atau ke feedlot yang salah. Sebelumnya
  /// halaman ini hanya menyebut nama dan alamat surel, sehingga pertanyaan
  /// kedua tidak terjawab di sini sama sekali.
  Widget _profileCard(AccountState state) {
    final colors = AppColors.current;

    return Container(
      padding: const EdgeInsets.all(Dimens.d20),
      decoration: BoxDecoration(
        color: colors.mint800,
        borderRadius: BorderRadius.circular(Dimens.d24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarWidget(avatarUrl: '', name: state.userData.full_name),
              const SizedBox(width: Dimens.d14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.userData.full_name.defaultValue('-'),
                      style: TextStyles.heading6().copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimens.d4),
                    Text(
                      state.userData.email.defaultValue('-'),
                      style: TextStyles.label2().copyWith(
                        color: colors.mint300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.d18),
          Divider(height: 1, thickness: 1, color: colors.mint700),
          const SizedBox(height: Dimens.d16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _profileFact(
                  icon: Icons.apartment_outlined,
                  label: 'Organisasi',
                  value: state.userData.clientSlug,
                ),
              ),
              const SizedBox(width: Dimens.d12),
              Expanded(
                child: _profileFact(
                  icon: Icons.agriculture_outlined,
                  label: 'Feedlot aktif',
                  value: state.feedlotName,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileFact({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colors = AppColors.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: Dimens.d14, color: colors.mint300),
            const SizedBox(width: Dimens.d6),
            Expanded(
              child: Text(
                label,
                style: TextStyles.label3().copyWith(color: colors.mint300),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.d4),
        Text(
          value.defaultValue('-'),
          style: TextStyles.body3().copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Satu kelompok menu dalam satu bidang putih.
  ///
  /// Garis pemisah hanya di antara baris dan menjorok sejauh lencana ikon,
  /// supaya kelompoknya terbaca utuh dan garisnya tidak memotong kartu dari
  /// tepi ke tepi.
  Widget _menuCard(List<AccountMenuItem> items) {
    final colors = AppColors.current;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.d20),
        border: Border.all(color: colors.neutral300),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: Dimens.d70,
                color: colors.neutral300,
              ),
            ListItemWidget(menuItem: items[i]),
          ],
        ],
      ),
    );
  }

  Widget _footer() {
    final colors = AppColors.current;

    return Column(
      children: [
        Text(
          EnvConstants.appName,
          style: TextStyles.label2().copyWith(
            fontWeight: FontWeight.w600,
            color: colors.neutral600,
          ),
        ),
        const SizedBox(height: Dimens.d2),
        Text(
          'Versi ${EnvConstants.appVersion}',
          style: TextStyles.label3().copyWith(color: colors.neutral600),
        ),
      ],
    );
  }
}
