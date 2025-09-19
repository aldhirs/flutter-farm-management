import 'package:auto_route/auto_route.dart';
import 'package:farm/domain/usecases/is_logged_in_use_case.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/navigation/middleware/auth_guard.dart';
import 'package:farm/navigation/middleware/first_launch_guard.dart';
import 'package:farm/navigation/routes/app_router.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
@LazySingleton()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  final _isLoggedInUseCase = GetIt.instance.get<IsLoggedInUseCase>();

  FirstLaunchGuard firstLaunchGuard() => FirstLaunchGuard(_isLoggedInUseCase);

  AuthGuard authGuard() => AuthGuard(_isLoggedInUseCase);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: WelcomeRoute.page,
      initial: true,
      guards: [firstLaunchGuard()],
    ),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(
      page: HomeNavBarRoute.page,
      guards: [authGuard()],
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: AccountRoute.page),
      ],
    ),
    AutoRoute(page: DraftingScanRoute.page, guards: [authGuard()]),
    AutoRoute(page: DraftingDetailRoute.page, guards: [authGuard()]),
    AutoRoute(page: DraftingFormRoute.page, guards: [authGuard()]),
    AutoRoute(page: CattleCreateRoute.page, guards: [authGuard()]),
    AutoRoute(page: SalesRoute.page, guards: [authGuard()]),
    AutoRoute(page: SalesItemsRoute.page, guards: [authGuard()]),
    AutoRoute(page: SalesItemPreviewRoute.page, guards: [authGuard()]),
    AutoRoute(page: SalesItemAddRoute.page, guards: [authGuard()]),
    AutoRoute(page: ScanRoute.page, guards: [authGuard()]),
    AutoRoute(page: PenDraftingRoute.page, guards: [authGuard()]),
    AutoRoute(
      page: MutationNavBarRoute.page,
      guards: [authGuard()],
      children: [
        AutoRoute(page: MutationListInRoute.page),
        AutoRoute(page: MutationListOutRoute.page),
      ],
    ),
    AutoRoute(page: MutationItemsRoute.page, guards: [authGuard()]),
    AutoRoute(page: MutationItemPreviewRoute.page, guards: [authGuard()]),
    AutoRoute(page: CattlePreviewRoute.page, guards: [authGuard()]),
    AutoRoute(page: CattleSearchRoute.page, guards: [authGuard()]),
    AutoRoute(page: DashboardRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // optionally add root guards here
  ];
}
