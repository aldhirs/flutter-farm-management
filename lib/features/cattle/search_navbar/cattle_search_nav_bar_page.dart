import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/cattle/search/cattle_search_page.dart';
import 'package:farm/features/cattle/search_navbar/bloc/cattle_search_nav_bar_event.dart';
import 'package:farm/features/cattle/search_navbar/bloc/cattle_search_nav_bar_bloc.dart';
import 'package:farm/navigation/app_navigator_impl.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CattleSearchNavBarPage extends StatefulWidget {
  const CattleSearchNavBarPage({super.key});

  @override
  State<StatefulWidget> createState() => _CattleSearchNavBarPageState();
}

class _CattleSearchNavBarPageState
    extends BasePageState<CattleSearchNavBarPage, CattleSearchNavBarBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());
  }

  @override
  Widget buildPage(BuildContext context) {
    return AutoTabsRouter(
      routes: (navigator as AppNavigatorImpl).cattleSearchNavBarRoutes,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return DefaultTabController(
          length:
              (navigator as AppNavigatorImpl).cattleSearchNavBarRoutes.length,
          initialIndex: tabsRouter.activeIndex,
          child: CommonScaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF25AFCB),
                      AppColors.current.mint500,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Data Sapi',
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
                  Tab(text: "Informasi"),
                  Tab(text: "Treatment"),
                  Tab(text: "Medis"),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                CattleSearchPage(),
                CattleSearchPage(),
                CattleSearchPage(),
              ],
            ),
          ),
        );
      },
    );
  }
}
