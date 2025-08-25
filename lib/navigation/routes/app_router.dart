import 'package:auto_route/auto_route.dart';
import 'package:farm/navigation/routes/app_router.gr.dart';
import 'package:injectable/injectable.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
@LazySingleton()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  // final _firstLaunchAppUseCase = GetIt.instance.get<IsFirstLaunchAppUseCase>();
  // final _isLoggedInUseCase = GetIt.instance.get<IsLoggedInUseCase>();

  // AuthGuard authGuard() => AuthGuard(_isLoggedInUseCase);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: WelcomeRoute.page,
      initial: true,
      // guards: [FirstLaunchGuard(_firstLaunchAppUseCase, _isLoggedInUseCase)],
    ),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: HomeRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // optionally add root guards here
  ];
}
