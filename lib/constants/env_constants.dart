import 'package:farm/constants/enum_constants.dart';
import 'package:farm/utils/log_utils.dart';

class EnvConstants {
  const EnvConstants._();

  static const appName = 'AGRISATWA';

  /// Nomor versi yang ditampilkan di halaman akun.
  ///
  /// Harus sama dengan `version:` di pubspec.yaml. Ditaruh di sini, bukan
  /// ditulis langsung di halamannya: yang sebelumnya tertulis di sana adalah
  /// "v1.0.0" sementara aplikasinya sudah 1.0.10, dan angka yang salah di
  /// layar ini menyesatkan justru ketika paling dibutuhkan — saat seseorang
  /// melaporkan masalah dan ditanya versi berapa yang ia pakai.
  static const appVersion = '1.0.10';
  static const flavorKey = 'FLAVOR';
  static const appBasicAuthNameKey = 'APP_BASIC_AUTH_NAME';
  static const appBasicAuthPasswordKey = 'APP_BASIC_AUTH_PASSWORD';

  static late Flavor flavor = Flavor.values.byName(
    const String.fromEnvironment(flavorKey, defaultValue: 'develop'),
  );
  static late String appBasicAuthName = const String.fromEnvironment(
    appBasicAuthNameKey,
  );
  static late String appBasicAuthPassword = const String.fromEnvironment(
    appBasicAuthPasswordKey,
  );

  static void init() {
    Log.d(flavor, name: flavorKey);
    Log.d(appBasicAuthName, name: appBasicAuthNameKey);
    Log.d(appBasicAuthPassword, name: appBasicAuthPasswordKey);
  }
}
