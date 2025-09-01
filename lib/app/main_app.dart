import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:farm/app/bloc/app_bloc.dart';
import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/app/bloc/app_state.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/ui/device_constants.dart';
import 'package:farm/constants/ui/ui_constants.dart';
import 'package:farm/navigation/routes/app_router.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends BasePageState<MainApp, AppBloc> {
  final _appRouter = GetIt.instance.get<AppRouter>();

  @override
  bool get isAppWidget => true;

  @override
  void initState() {
    super.initState();
    bloc.add(const AppInitiated());
  }

  List<NavigatorObserver> getNavigationObservers() {
    final List<NavigatorObserver> navigatorObservers = [];
    if (kDebugMode || kProfileMode) {
      navigatorObservers.add(ChuckerFlutter.navigatorObserver);
    }
    return navigatorObservers;
  }

  // This widget is the root of your application.
  @override
  Widget buildPage(BuildContext context) {
    return ScreenUtilInit(
      key: navKey,
      designSize: const Size(
        DeviceConstants.designDeviceWidth,
        DeviceConstants.designDeviceHeight,
      ),
      builder: (context, _) => BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) =>
            previous.isDarkTheme != current.isDarkTheme,
        builder: (context, state) {
          return MaterialApp.router(
            // showPerformanceOverlay: true, // FPS and GPU
            // checkerboardRasterCacheImages: true,
            // checkerboardOffscreenLayers: true,
            // showSemanticsDebugger: true,
            // debugShowMaterialGrid: true,
            builder: (context, child) {
              final MediaQueryData data = MediaQuery.of(context);

              return MediaQuery(
                data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child ?? const SizedBox.shrink(),
              );
            },
            title: UiConstants.materialAppTitle,
            color: UiConstants.taskMenuMaterialAppColor,
            themeMode: state.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: true,
            routerDelegate: _appRouter.delegate(
              navigatorObservers: () => getNavigationObservers(),
            ),
            routeInformationParser: _appRouter.defaultRouteParser(),
          );
        },
      ),
    );
  }
}
