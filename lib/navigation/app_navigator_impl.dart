import 'package:auto_route/auto_route.dart';
import 'package:farm/base/log/mixin/log_mixin.dart';
import 'package:farm/config/log_config.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/navigation/base/base_route_info_mapper.dart';
import 'package:farm/navigation/routes/app_router.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/widgets/bottomsheet/bottomsheet_container.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppNavigator)
class AppNavigatorImpl extends AppNavigator with LogMixin {
  AppNavigatorImpl(this._appRouter, this._appRouteInfoMapper);

  // final homeNavBarRoutes = const [MyProgramRoute(), AccountRoute()];

  TabsRouter? tabsRouter;

  final AppRouter _appRouter;
  final BaseRouteInfoMapper _appRouteInfoMapper;
  final _popupsContent = <Widget>{};

  StackRouter? get _currentTabRouter =>
      tabsRouter?.stackRouterOfIndex(currentBottomTab);

  StackRouter get _currentTabRouterOrRootRouter =>
      _currentTabRouter ?? _appRouter;

  m.BuildContext get _rootRouterContext =>
      _appRouter.navigatorKey.currentContext!;

  m.BuildContext? get _currentHomeTabRouterContext =>
      _currentTabRouter?.navigatorKey.currentContext;

  m.BuildContext get _currentTabContextOrRootContext =>
      _currentHomeTabRouterContext ?? _rootRouterContext;

  @override
  int get currentBottomTab {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }

    return tabsRouter?.activeIndex ?? 0;
  }

  @override
  bool get canPopSelfOrChildren => _appRouter.canPop();

  @override
  String getCurrentRouteName({bool useRootNavigator = false}) => AutoRouter.of(
    useRootNavigator ? _rootRouterContext : _currentTabContextOrRootContext,
  ).current.name;

  @override
  void popUntilRootOfCurrentBottomTab() {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }

    if (_currentTabRouter?.canPop() == true) {
      if (LogConfig.enableNavigatorObserverLog) {
        logD('popUntilRootOfCurrentBottomTab');
      }
      _currentTabRouter?.popUntilRoot();
    }
  }

  @override
  void navigateToBottomTab(int index, {bool notify = true}) {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }

    if (LogConfig.enableNavigatorObserverLog) {
      logD('navigateToBottomTab with index = $index, notify = $notify');
    }
    tabsRouter?.setActiveIndex(index, notify: notify);
  }

  @override
  Future<T?> push<T extends Object?>(AppRouteInfo appRouteInfo) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('push $appRouteInfo');
    }

    return _appRouter.push<T>(_appRouteInfoMapper.map(appRouteInfo));
  }

  @override
  Future<T?> pushRoute<T extends Object?>(dynamic route) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('push route $route');
    }
    try {
      return _appRouter.push<T>(route);
    } catch (e) {
      logE('push route error $e');
    }
    return Future<T>.value(null);
  }

  @override
  void pushAndPopUntil(AppRouteInfo appRouteInfo) {
    _appRouter.pushAndPopUntil(
      _appRouteInfoMapper.map(appRouteInfo),
      predicate: (route) => false,
    );
  }

  @override
  Future<void> navigate<T extends Object?>(AppRouteInfo appRouteInfo) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('navigate $appRouteInfo');
    }

    return _appRouter.navigate(_appRouteInfoMapper.map(appRouteInfo));
  }

  @override
  Future<void> pushAll(List<AppRouteInfo> listAppRouteInfo) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('pushAll $listAppRouteInfo');
    }

    return _appRouter.pushAll(_appRouteInfoMapper.mapList(listAppRouteInfo));
  }

  @override
  Future<T?> replace<T extends Object?>(AppRouteInfo appRouteInfo) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('replace by $appRouteInfo');
    }

    return _appRouter.replace<T>(_appRouteInfoMapper.map(appRouteInfo));
  }

  @override
  Future<void> replaceAll(List<AppRouteInfo> listAppRouteInfo) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('replaceAll by $listAppRouteInfo');
    }

    return _appRouter.replaceAll(_appRouteInfoMapper.mapList(listAppRouteInfo));
  }

  @override
  Future<bool> pop<T extends Object?>({
    T? result,
    bool useRootNavigator = false,
  }) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('pop with result = $result, useRootNav = $useRootNavigator');
    }

    return useRootNavigator
        ? _appRouter.maybePop<T>(result)
        : _currentTabRouterOrRootRouter.maybePop<T>(result);
  }

  @override
  Future<T?> popAndPush<T extends Object?, R extends Object?>(
    AppRouteInfo appRouteInfo, {
    R? result,
    bool useRootNavigator = false,
  }) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD(
        'popAndPush $appRouteInfo with result = $result, useRootNav = $useRootNavigator',
      );
    }

    return useRootNavigator
        ? _appRouter.popAndPush<T, R>(
            _appRouteInfoMapper.map(appRouteInfo),
            result: result,
          )
        : _currentTabRouterOrRootRouter.popAndPush<T, R>(
            _appRouteInfoMapper.map(appRouteInfo),
            result: result,
          );
  }

  @override
  void popUntilRoot({bool useRootNavigator = false}) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('popUntilRoot, useRootNav = $useRootNavigator');
    }

    useRootNavigator
        ? _appRouter.popUntilRoot()
        : _currentTabRouterOrRootRouter.popUntilRoot();
  }

  @override
  void popUntilRouteName(String routeName) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('popUntilRouteName $routeName');
    }

    _appRouter.popUntilRouteWithName(routeName);
  }

  @override
  void popUntil(RoutePredicate predicate, {bool scoped = true}) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('popUntil $predicate');
    }
    _appRouter.popUntil(predicate, scoped: scoped);
  }

  @override
  void navigateNamed(String path) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('navigateNamed $path');
    }

    _appRouter.navigatePath(path);
  }

  @override
  void back() {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('back');
    }

    _appRouter.back();
  }

  @override
  bool removeUntilRouteName(String routeName) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('removeUntilRouteName $routeName');
    }

    return _appRouter.removeUntil((route) => route.name == routeName);
  }

  @override
  bool removeAllRoutesWithName(String routeName) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('removeAllRoutesWithName $routeName');
    }

    return _appRouter.removeWhere((route) => route.name == routeName);
  }

  @override
  Future<void> popAndPushAll(
    List<AppRouteInfo> listAppRouteInfo, {
    bool useRootNavigator = false,
  }) {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('popAndPushAll $listAppRouteInfo, useRootNav = $useRootNavigator');
    }

    return useRootNavigator
        ? _appRouter.popAndPushAll(
            _appRouteInfoMapper.mapList(listAppRouteInfo),
          )
        : _currentTabRouterOrRootRouter.popAndPushAll(
            _appRouteInfoMapper.mapList(listAppRouteInfo),
          );
  }

  @override
  bool removeLast() {
    if (LogConfig.enableNavigatorObserverLog) {
      logD('removeLast');
    }

    return _appRouter.removeLast();
  }

  @override
  Future<T?> showAppDialog<T extends Object?>(
    Widget content, {
    bool barrierDismissible = true,
    bool useSafeArea = false,
    bool useRootNavigator = true,
  }) {
    if (_popupsContent.contains(content)) {
      return Future.value(null);
    }
    _popupsContent.add(content);

    return m.showDialog<T>(
      context: useRootNavigator
          ? _rootRouterContext
          : _currentTabContextOrRootContext,
      builder: (_) => m.PopScope(
        onPopInvokedWithResult: (didPop, result) async {
          _popupsContent.remove(content);

          return Future.value();
        },
        child: content,
      ),
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
    );
  }

  @override
  Future<T?> showBottomSheet<T extends Object?>(
    m.Widget content, {
    bool isContentPlain = false,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    m.Color barrierColor = m.Colors.black54,
    m.Color? backgroundColor = m.Colors.white,
    VoidCallback? onDismiss,
  }) {
    return m
        .showModalBottomSheet<T>(
          context: useRootNavigator
              ? _rootRouterContext
              : _currentTabContextOrRootContext,
          builder: (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(
                useRootNavigator
                    ? _rootRouterContext
                    : _currentTabContextOrRootContext,
              ).viewInsets.bottom,
            ),
            child: BottomsheetContainer(
              content: content,
              isPlain: isContentPlain,
            ),
          ),
          isDismissible: isDismissible,
          constraints: BoxConstraints(
            maxWidth: DeviceUtils.getTabletFixFullWidth() ?? double.infinity,
          ),
          enableDrag: enableDrag,
          useRootNavigator: useRootNavigator,
          isScrollControlled: isScrollControlled,
          backgroundColor: backgroundColor,
          barrierColor: barrierColor,
        )
        .whenComplete(() {
          if (onDismiss != null) {
            onDismiss.call();
          }
        });
  }

  @override
  void showErrorSnackBar(String message, {Duration? duration}) {
    ViewUtils.showAppSnackBar(
      _rootRouterContext,
      message,
      duration: duration,
      backgroundColor: AppColors.current.crimson500,
    );
  }

  @override
  void showSuccessSnackBar(String message, {Duration? duration}) {
    ViewUtils.showAppSnackBar(
      _rootRouterContext,
      message,
      duration: duration,
      backgroundColor: AppColors.current.eucalyptus500,
    );
  }
}
