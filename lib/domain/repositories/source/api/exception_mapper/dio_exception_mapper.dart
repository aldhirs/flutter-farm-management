import 'dart:io';

import 'package:dio/dio.dart';
import 'package:farm/base/exception/base/exception_mapper.dart';
import 'package:farm/base/exception/remote/remote_exception.dart';
import 'package:farm/base/exception/remote/server_error.dart';

class DioExceptionMapper extends ExceptionMapper<RemoteException> {
  DioExceptionMapper();

  /// Membaca satu kunci dari badan respons, hanya bila badan itu memang peta.
  ///
  /// Badan galat tidak selalu JSON object: bisa teks biasa dari proksi, bisa
  /// larik, bisa kosong. Mengindeksnya langsung melempar, dan lemparan itu
  /// terjadi di dalam pemeta galat — tempat paling buruk untuk gagal, karena
  /// yang hilang justru penjelasan yang sedang coba diambil.
  Object? _read(Object? body, String key) {
    if (body is Map) {
      return body[key];
    }
    return null;
  }

  /// Menyusun pesan yang bisa dibaca dari bentuk `message` mana pun.
  ///
  /// Server memakai dua bentuk. Penolakan biasa mengirim kalimat tunggal.
  /// Galat validasi mengirim LARIK per-field —
  /// `[{"field":"EarTag","message":"Field is required"}]` — dan larik itu
  /// dulunya diteruskan begitu saja ke sebuah field bertipe String, yang
  /// melempar. Itulah sebabnya "tambah sapi" berakhir sebagai kegagalan tak
  /// tertangani padahal server sudah menyebutkan persis kolom mana yang kurang.
  ///
  /// Nama field ikut ditampilkan karena itulah bagian yang bisa ditindaklanjuti:
  /// "Field is required" sendirian tidak memberi tahu kolom mana yang kosong.
  String? _message(Object? body) {
    final raw = _read(body, 'message') ?? _read(body, 'error');

    if (raw is String) {
      return raw;
    }

    if (raw is List) {
      final lines = raw
          .map((item) {
            if (item is Map) {
              final field = item['field'];
              final text = item['message'];
              if (field is String && text is String) {
                return '$field: $text';
              }
              return text is String ? text : null;
            }
            return item is String ? item : null;
          })
          .whereType<String>()
          .toList();

      return lines.isEmpty ? null : lines.join('\n');
    }

    return null;
  }

  @override
  RemoteException map(Object? exception) {
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.cancel:
          return const RemoteException(kind: RemoteExceptionKind.cancellation);
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return RemoteException(
            kind: RemoteExceptionKind.timeout,
            rootException: exception,
          );
        case DioExceptionType.badResponse:
          final httpErrorCode = exception.response?.statusCode ?? -1;
          final body = exception.response?.data;

          /// server-defined error
          if (body != null && body != "") {
            final expired = _read(body, 'error') == 'token has expired';

            return RemoteException(
              kind: expired
                  ? RemoteExceptionKind.refreshTokenFailed
                  : RemoteExceptionKind.serverDefined,
              httpErrorCode: httpErrorCode,
              rootException: exception,
              serverError: ServerError(
                generalServerStatusCode: httpErrorCode,

                /// `code` dipakai server untuk menandai penolakan yang BUKAN
                /// soal izin: langganan habis, atau akses perusahaan
                /// dihentikan. Tanpa menyimpannya, ketiganya sampai ke layar
                /// sebagai 403 yang sama dan pesan yang ditulis pemilik sistem
                /// tidak pernah bisa dibedakan dari "halaman ini bukan untukmu".
                ///
                /// Hanya diambil bila berupa teks. Pada galat validasi server
                /// mengisi `code` dengan angka status (400), dan memaksanya
                /// menjadi String melempar TypeError DI DALAM mapper ini —
                /// sehingga galat yang sudah dijelaskan server berubah menjadi
                /// kegagalan tak tertangani, dan pengguna melihat kode umum
                /// alih-alih alasan sebenarnya.
                generalServerErrorId: _read(body, 'code') is String
                    ? _read(body, 'code') as String
                    : null,
                generalMessage: _message(body),
              ),
            );
          }

          return RemoteException(
            kind: RemoteExceptionKind.serverUndefined,
            httpErrorCode: httpErrorCode,
            rootException: exception,
            serverError: ServerError(
              generalServerStatusCode: httpErrorCode,
              generalMessage:
                  exception.response?.statusMessage ?? exception.message,
            ),
          );
        case DioExceptionType.badCertificate:
          return RemoteException(
            kind: RemoteExceptionKind.badCertificate,
            rootException: exception,
          );
        case DioExceptionType.connectionError:
          return RemoteException(
            kind: RemoteExceptionKind.network,
            rootException: exception,
          );
        case DioExceptionType.unknown:
          if (exception is SocketException) {
            return RemoteException(
              kind: RemoteExceptionKind.network,
              rootException: exception,
            );
          }

          if (exception.error is RemoteException) {
            return exception.error as RemoteException;
          }
      }
    }

    return RemoteException(
      kind: RemoteExceptionKind.unknown,
      rootException: exception,
    );
  }
}
