import 'package:farm/base/exception/base/app_exception.dart';
import 'package:farm/base/exception/remote/remote_exception.dart';

/// Mengubah kegagalan teknis menjadi kalimat yang pantas dibaca pengguna.
///
/// Satu aturan yang berlaku untuk semuanya: yang sampai ke layar adalah kalimat
/// yang memang ditulis untuk dibaca orang — entah oleh server, entah oleh kelas
/// ini. Isi objek exception tidak pernah ikut.
///
/// Sebelumnya `rootException.toString()` dipakai sebagai cadangan ketika server
/// tidak mengirim pesan, sehingga petugas kandang bisa melihat potongan seperti
/// `DioException [connection error]: SocketException: Connection refused
/// (OS Error: Connection refused, errno = 61), address = localhost, port = 8080`
/// di tengah layar. Itu tidak memberi tahu apa pun yang bisa ia lakukan, dan
/// membuat aplikasi terlihat rusak untuk hal sesederhana wifi yang putus.
class ExceptionMessageMapper {
  const ExceptionMessageMapper();

  /// Kalimat cadangan ketika tidak ada pesan yang layak ditampilkan.
  static const _generic = 'Terjadi kesalahan, silakan coba lagi.';

  /// Penolakan yang bukan soal izin, melainkan soal status perusahaan.
  ///
  /// Server memisahkan keduanya dengan sengaja: langganan yang habis membawa
  /// tanggal yang disepakati berbulan-bulan lalu, sedangkan akses yang
  /// dihentikan membawa kalimat yang ditulis pemilik sistem dan bisa dicabut
  /// kapan saja. Keduanya sudah berupa kalimat untuk dibaca orang, jadi
  /// ditampilkan apa adanya — tanpa awalan kode status, yang hanya membuat
  /// urusan administratif terlihat seperti kerusakan teknis.
  static const _clientBlockedCodes = {'client_overdue', 'client_suspended'};

  String map(AppException appException) {
    switch (appException.appExceptionType) {
      case AppExceptionType.remote:
        return _mapRemote(appException as RemoteException);
      case AppExceptionType.parse:
        return _withCode(_generic, 'APP-01');
      case AppExceptionType.remoteConfig:
        return _withCode(_generic, 'APP-02');
      case AppExceptionType.uncaught:
        return _withCode(_generic, 'APP-03');
      case AppExceptionType.validation:
        return _withCode('Data yang dikirim belum sesuai.', 'APP-04');
    }
  }

  String _mapRemote(RemoteException exception) {
    final serverMessage = exception.generalServerMessage?.trim();
    final hasServerMessage = serverMessage != null && serverMessage.isNotEmpty;

    if (_clientBlockedCodes.contains(exception.generalServerErrorId) &&
        hasServerMessage) {
      return serverMessage;
    }

    /// Pesan dari server dipakai lebih dulu, karena hanya server yang tahu apa
    /// yang sebenarnya ditolak — "stok tidak mencukupi" jauh lebih berguna
    /// daripada kalimat umum mana pun yang bisa ditulis di sini.
    if (hasServerMessage) {
      return serverMessage;
    }

    /// Masalah jaringan disebut apa adanya, bukan digenerikkan.
    ///
    /// Ini satu-satunya golongan kegagalan yang bisa ditindaklanjuti sendiri
    /// oleh pengguna, dan menyembunyikannya di balik "terjadi kesalahan" justru
    /// membuatnya menghubungi tim teknis untuk urusan sinyal.
    switch (exception.kind) {
      case RemoteExceptionKind.noInternet:
        return 'Tidak ada koneksi internet. Periksa jaringan lalu coba lagi.';
      case RemoteExceptionKind.network:
        return 'Gagal terhubung ke server. Periksa jaringan lalu coba lagi.';
      case RemoteExceptionKind.timeout:
        return 'Server terlalu lama merespons. Silakan coba lagi.';
      case RemoteExceptionKind.refreshTokenFailed:
        return 'Sesi Anda telah berakhir. Silakan masuk kembali.';
      case RemoteExceptionKind.cancellation:
        return 'Permintaan dibatalkan.';
      case RemoteExceptionKind.badCertificate:
      case RemoteExceptionKind.serverDefined:
      case RemoteExceptionKind.serverUndefined:
      case RemoteExceptionKind.unknown:
        return _withCode(_generic, _code(exception));
    }
  }

  /// Kode singkat untuk ditunjukkan ke tim teknis.
  ///
  /// Status HTTP dipakai bila ada, karena itulah yang paling menyempitkan
  /// pencarian di log. Kode ini menggantikan detail teknis, bukan mendampinginya:
  /// pengguna cukup menyebut angkanya, dan yang membaca log yang menerjemahkan.
  String _code(RemoteException exception) {
    final status = exception.generalServerStatusCode;
    if (status > 0) {
      return 'HTTP-$status';
    }
    return switch (exception.kind) {
      RemoteExceptionKind.badCertificate => 'NET-02',
      RemoteExceptionKind.serverDefined => 'SRV-01',
      RemoteExceptionKind.serverUndefined => 'SRV-02',
      _ => 'ERR-01',
    };
  }

  String _withCode(String message, String code) => '$message (kode: $code)';
}
