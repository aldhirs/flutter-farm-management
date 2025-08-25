import 'package:farm/constants/env_constants.dart';
import 'package:farm/constants/enum_constants.dart';

class UrlConstants {
  const UrlConstants._();

  /// Url
  static const randomUserBaseUrl = 'https://randomuser.me/api/';

  static const mockApiBaseUrl =
      'https://private-3e1d3b-yanesrivkiyunius.apiary-mock.com';

  static String get appBaseUrl {
    switch (EnvConstants.flavor) {
      case Flavor.develop:
        return 'https://api.dev.xxx';
      case Flavor.staging:
        return 'https://api.staging.xxx';
      case Flavor.production:
        return 'https://api.xxx';
    }
  }
}
