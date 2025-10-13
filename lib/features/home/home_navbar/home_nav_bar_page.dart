import 'package:auto_route/auto_route.dart';
import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_state.dart';
import 'package:farm/features/home/home_navbar/drafting_cattle_bottom_sheet.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_bloc.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_event.dart';
import 'package:farm/features/scan/scan_page.dart';
import 'package:farm/navigation/app_navigator_impl.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeNavBarPage extends StatefulWidget {
  const HomeNavBarPage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeNavBarPageState();
}

class _HomeNavBarPageState
    extends BasePageState<HomeNavBarPage, HomeNavBarBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeNavBarBloc, HomeNavBarState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) async {
            if (state.cattle != null) {
              navigator.popAndPush(
                AppRouteInfo.draftingForm(cattle: state.cattle),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return AutoTabsRouter(
      routes: (navigator as AppNavigatorImpl).homeNavBarRoutes,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          extendBody: true, // Important for notch to work correctly
          body: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 60,
            ),
            child: child,
          ), // Displays the content of the current tab
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton.large(
            backgroundColor: AppColors.current.mint600,
            onPressed: () => _onDraftingClicked(),
            shape: const CircleBorder(),
            child: const Icon(Icons.barcode_reader, color: Colors.white),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: AppColors.current.neutral100,
            notchMargin: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home
                InkWell(
                  onTap: () => tabsRouter.setActiveIndex(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: tabsRouter.activeIndex == 0
                            ? AppColors.current.mint700
                            : AppColors.current.neutral800,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Beranda',
                        style: TextStyle(
                          fontSize: 12,
                          color: tabsRouter.activeIndex == 0
                              ? AppColors.current.mint700
                              : AppColors.current.neutral800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 30), // Space for FAB
                // Settings
                InkWell(
                  onTap: () => tabsRouter.setActiveIndex(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: tabsRouter.activeIndex == 1
                            ? AppColors.current.mint700
                            : AppColors.current.neutral800,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Akun',
                        style: TextStyle(
                          fontSize: 12,
                          color: tabsRouter.activeIndex == 1
                              ? AppColors.current.mint700
                              : AppColors.current.neutral800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onShowFeedlotAlert() {
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        title: 'Feedlot belum diisi',
        illustration: ClipRRect(
          borderRadius: BorderRadius.circular(20), // adjust radius
          child: Assets.images.ilCowFeedlot.image(
            height: Dimens.d140,
            fit: BoxFit.cover,
          ),
        ),
        description: [
          const TextSpan(
            text:
                "Silakan untuk memilih feedlot terlebih dahulu untuk melanjutkan aktivitas.",
          ),
        ],
        positiveButtonText: "Pilih Feedlot",
        onPositiveButtonPressed: () async {
          navigator.pop();
          appBloc.add(const ShowProjects());
        },
      ),
    );
  }

  void _onDraftingClicked() async {
    if (appBloc.state.selectedProject == null) {
      _onShowFeedlotAlert();
      return;
    }
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        closeVisibility: true,
        title: 'Drafting Sapi',
        illustration: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Assets.images.ilCowScanning.image(
            height: Dimens.d160,
            fit: BoxFit.cover,
          ),
        ),
        description: const [
          TextSpan(
            text:
                'Silakan pilih metode dalam drafting sapi menggunakan alat pemindai atau manual berdasarakan ear tag.',
          ),
        ],
        positiveButtonText: "Cari dengan Alat",
        negativeButtonText: "Cari Manual",
        onNegativeButtonPressed: _draftingCattleManualBottomSheet,
        onPositiveButtonPressed: () async {
          await navigator.popAndPush(
            const AppRouteInfo.scan(route: DEST_DRAFTING_DETAIL),
          );
        },
      ),
    );
  }

  void _draftingCattleManualBottomSheet() async {
    await navigator.pop();
    await navigator.showBottomSheet(
      isScrollControlled: true,
      DraftingCattleBottomSheet(bloc: bloc, onDismiss: () => navigator.pop()),
    );
  }
}
