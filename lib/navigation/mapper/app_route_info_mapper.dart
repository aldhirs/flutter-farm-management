import 'package:auto_route/auto_route.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/navigation/base/base_route_info_mapper.dart';
import 'package:farm/navigation/routes/app_router.gr.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BaseRouteInfoMapper)
class AppRouteInfoMapper extends BaseRouteInfoMapper {
  @override
  PageRouteInfo map(AppRouteInfo appRouteInfo) {
    return switch (appRouteInfo) {
      Welcome() => const WelcomeRoute(),
      Login(:final messageChangePassword) => LoginRoute(
        messageSuccessChangePassword: messageChangePassword,
      ),
      Home() => const HomeRoute(),
      _ => throw UnimplementedError('Unknown route: $appRouteInfo'),
    };
  }
}
