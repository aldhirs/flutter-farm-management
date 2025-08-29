import 'package:farm/config/app_config.dart';
import 'package:farm/config/config.dart';
import 'package:farm/constants/env_constants.dart';

abstract class ApplicationConfig extends Config {}

class AppInitializer {
  AppInitializer();

  Future<void> init() async {
    EnvConstants.init();
    await AppConfig.getInstance().init();
  }
}
