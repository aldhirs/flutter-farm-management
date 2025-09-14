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
      Home() => const HomeNavBarRoute(),
      DraftingScan() => const DraftingScanRoute(),
      DraftingDetail(:final connection) => DraftingDetailRoute(
        connection: connection,
      ),
      DraftingForm(:final rfid, :final cattle) => DraftingFormRoute(
        rfid: rfid,
        cattle: cattle,
      ),
      CattleCreate(:final connection, :final rfid) => CattleCreateRoute(
        connection: connection,
        rfid: rfid,
      ),
      Account() => const AccountRoute(),
      SalesPage() => const SalesRoute(),
      SalesItemPage(:final item) => SalesItemsRoute(item: item),
      SalesItemPreviewPage(:final item, :final connection) =>
        SalesItemPreviewRoute(item: item, connection: connection),
      SalesItemAddPage(
        :final item,
        :final fromManual,
        :final cattle,
        :final rfid,
        :final connection,
      ) =>
        SalesItemAddRoute(
          item: item,
          cattle: cattle,
          rfid: rfid,
          connection: connection,
          fromManual: fromManual,
        ),
      ScanPages(:final route, :final sales, :final mutation) =>
        sales != null
            ? ScanRoute(destinationRoute: route, sales: sales)
            : mutation != null
            ? ScanRoute(destinationRoute: route, mutation: mutation)
            : ScanRoute(destinationRoute: route),
      PenDrafting() => const PenDraftingRoute(),

      MutationNavBar() => const MutationNavBarRoute(),
      MutationItemPage(:final item, :final isIn) => MutationItemsRoute(
        item: item,
        isIn: isIn,
      ),
      MutationItemPreviewPage(:final item, :final connection) =>
        MutationItemPreviewRoute(item: item, connection: connection),
      _ => throw UnimplementedError('Unknown route: $appRouteInfo'),
    };
  }
}
