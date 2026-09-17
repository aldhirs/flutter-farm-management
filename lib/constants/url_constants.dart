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
        // Backend lokal, untuk dipakai sementara saat mengembangkan:
        //   return 'http://localhost:8080/api';
        // Di perangkat yang tersambung USB jalankan dulu
        // `adb reverse tcp:8080 tcp:8080`; di emulator pakai 10.0.2.2.
        return 'https://api.agrisatwajayakencana.id/api';
      case Flavor.staging:
        return 'https://api.agrisatwajayakencana.id/api';
      case Flavor.production:
        return 'https://api.agrisatwajayakencana.id/api';
    }
  }
}
