import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/mutation/list/mutation_list_page.dart';
import 'package:farm/features/mutation/navbar/bloc/mutation_nav_bar_bloc.dart';
import 'package:farm/features/mutation/navbar/bloc/mutation_nav_bar_event.dart';
import 'package:farm/navigation/app_navigator_impl.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MutationNavBarPage extends StatefulWidget {
  const MutationNavBarPage({super.key});

  @override
  State<StatefulWidget> createState() => _MutationNavBarPageState();
}

class _MutationNavBarPageState
    extends BasePageState<MutationNavBarPage, MutationNavBarBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());
  }

  @override
  Widget buildPage(BuildContext context) {
    return AutoTabsRouter(
      routes: (navigator as AppNavigatorImpl).mutationNavBarRoutes,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return DefaultTabController(
          length: (navigator as AppNavigatorImpl).mutationNavBarRoutes.length,
          initialIndex: tabsRouter.activeIndex,
          child: CommonScaffold(
            appBar: AppBar(
              title: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Daftar Mutasi',
                  style: TextStyles.heading6().copyWith(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                ),
              ),
              bottom: TabBar(
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, // 👈 aktif bold
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal, // 👈 tidak aktif normal
                ),
                labelColor: Colors.white, // 👈 aktif hitam (atau sesuai tema)
                unselectedLabelColor: AppColors.current.neutral100,
                indicatorColor: AppColors
                    .current
                    .mint700, // opsional: garis bawah tab aktif
                onTap: (index) => tabsRouter.setActiveIndex(index),
                tabs: const [
                  Tab(text: "Masuk"),
                  Tab(text: "Keluar"),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                MutationListPage(isIn: true),
                MutationListPage(isIn: false),
              ],
            ),
          ),
        );
      },
    );
  }
}
