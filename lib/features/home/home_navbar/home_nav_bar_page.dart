import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_bloc.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_event.dart';
import 'package:farm/navigation/app_navigator_impl.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';

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
            onPressed: () async {
              if (appBloc.state.selectedProject == null) {
                navigator.showAppDialog(
                  useRootNavigator: true,
                  barrierDismissible: false,
                  Popup(
                    title: 'Pilih Feedlot terlebih dahulu',
                    description: [
                      const TextSpan(
                        text: "harap pilih feedlot terlebih dahulu.",
                      ),
                    ],
                    positiveButtonText: "Mengerti",
                    onPositiveButtonPressed: () async {
                      navigator.pop();
                    },
                  ),
                );
              } else {
                await navigator.push(const AppRouteInfo.draftingScan());
              }
            },
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
}
