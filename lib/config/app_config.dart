import 'package:farm/base/bloc/app_bloc_observer.dart';
import 'package:farm/config/config.dart';
import 'package:farm/constants/ui/ui_constants.dart';
import 'package:farm/di/di.dart' as di;
import 'package:farm/constants/env_constants.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConfig extends ApplicationConfig {
  factory AppConfig.getInstance() {
    return _instance;
  }

  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  @override
  Future<void> config() async {
    di.configureInjection();
    Bloc.observer = AppBlocObserver();
    await ViewUtils.setPreferredOrientations(
      DeviceUtils.getDeviceType() == DeviceType.mobile
          ? UiConstants.mobileOrientation
          : UiConstants.tabletOrientation,
    );
    ViewUtils.setSystemUIOverlayStyle(UiConstants.systemUiOverlay);
    // await LocalPushNotificationHelper.init();
  }
}

abstract class ApplicationConfig extends Config {}

class AppInitializer {
  AppInitializer(this._applicationConfig);

  final ApplicationConfig _applicationConfig;

  Future<void> init() async {
    EnvConstants.init();
    await _applicationConfig.init();
  }
}
