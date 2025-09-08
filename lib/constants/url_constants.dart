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
        return 'http://192.168.1.6:8080/api';
      case Flavor.staging:
        return 'https://api.agrisatwa.teknoduct.com/api';
      case Flavor.production:
        return 'https://api.xxx';
    }
  }
}
