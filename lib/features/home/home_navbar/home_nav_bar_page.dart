import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_bloc.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_event.dart';
import 'package:farm/features/scan/scan_page.dart';
import 'package:farm/navigation/app_navigator_impl.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

@RoutePage()
class HomeNavBarPage extends StatefulWidget {
  const HomeNavBarPage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeNavBarPageState();
}

class _HomeNavBarPageState
    extends BasePageState<HomeNavBarPage, HomeNavBarBloc> {
  final AudioPlayer _player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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
            backgroundColor: AppColors.current.mint700,
            onPressed: () => _onDraftingClicked(),
            shape: const CircleBorder(),
            child: const Icon(Icons.barcode_reader, color: Colors.white),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: AppColors.current.neutral100,
            notchMargin: 12.0, // Adjust margin as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: tabsRouter.activeIndex == 0
                        ? AppColors.current.mint700
                        : AppColors.current.neutral800,
                  ),
                  onPressed: () => tabsRouter.setActiveIndex(0),
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: tabsRouter.activeIndex == 1
                        ? AppColors.current.mint700
                        : AppColors.current.neutral800,
                  ),
                  onPressed: () => tabsRouter.setActiveIndex(1),
                ),
                // Add more navigation items, leaving space for the FAB if necessary
              ],
            ),
          ),
        );
      },
    );
  }

  void _onDraftingClicked() async {
    if (appBloc.state.selectedProject == null) {
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
    } else {
      await navigator.push(
        const AppRouteInfo.scan(route: DEST_DRAFTING_DETAIL),
      );
    }
  }
}
