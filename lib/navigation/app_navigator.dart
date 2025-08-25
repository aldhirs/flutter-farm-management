import 'package:farm/navigation/app_route_info.dart';
import 'package:flutter/material.dart';

abstract class AppNavigator {
  const AppNavigator();

  bool get canPopSelfOrChildren;

  int get currentBottomTab;

  String getCurrentRouteName({bool useRootNavigator = false});

  void popUntilRootOfCurrentBottomTab();

  void navigateToBottomTab(int index, {bool notify = true});

  Future<T?> push<T extends Object?>(AppRouteInfo appRouteInfo);

  Future<T?> pushRoute<T extends Object?>(dynamic route);

  Future<void> navigate<T extends Object?>(AppRouteInfo appRouteInfo);

  Future<void> pushAll(List<AppRouteInfo> listAppRouteInfo);

  Future<T?> replace<T extends Object?>(AppRouteInfo appRouteInfo);

  Future<void> replaceAll(List<AppRouteInfo> listAppRouteInfo);

  Future<bool> pop<T extends Object?>({
    T? result,
    bool useRootNavigator = false,
  });

  Future<T?> popAndPush<T extends Object?, R extends Object?>(
    AppRouteInfo appRouteInfo, {
    R? result,
    bool useRootNavigator = false,
  });

  Future<void> popAndPushAll(
    List<AppRouteInfo> listAppRouteInfo, {
    bool useRootNavigator = false,
  });

  void popUntilRoot({bool useRootNavigator = false});

  void popUntil(RoutePredicate predicate, {bool scoped = true});

  void popUntilRouteName(String routeName);

  void navigateNamed(String path);

  void back();

  void pushAndPopUntil(AppRouteInfo appRouteInfo);

  bool removeUntilRouteName(String routeName);

  bool removeAllRoutesWithName(String routeName);

  bool removeLast();

  Future<T?> showAppDialog<T extends Object?>(
    Widget content, {
    bool barrierDismissible = true,
    bool useSafeArea = false,
    bool useRootNavigator = true,
  });

  Future<T?> showBottomSheet<T extends Object?>(
    Widget content, {
    bool isContentPlain = false,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color barrierColor = Colors.black54,
    Color? backgroundColor,
    VoidCallback? onDismiss,
  });

  void showErrorSnackBar(String message, {Duration? duration});

  void showSuccessSnackBar(String message, {Duration? duration});
}
