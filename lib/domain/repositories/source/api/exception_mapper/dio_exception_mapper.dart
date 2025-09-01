import 'dart:io';

import 'package:dio/dio.dart';
import 'package:farm/base/exception/base/exception_mapper.dart';
import 'package:farm/base/exception/remote/remote_exception.dart';
import 'package:farm/base/exception/remote/server_error.dart';

class DioExceptionMapper extends ExceptionMapper<RemoteException> {
  DioExceptionMapper();

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

          /// server-defined error
          if (exception.response?.data != null) {
            final expired =
                exception.response?.data["error"] == 'token has expired';

            return RemoteException(
              kind: expired
                  ? RemoteExceptionKind.refreshTokenFailed
                  : RemoteExceptionKind.serverDefined,
              httpErrorCode: httpErrorCode,
              rootException: exception,
              serverError: ServerError(
                generalMessage:
                    exception.response?.data["message"] ??
                    exception.response?.data["error"],
              ),
            );
          }

          return RemoteException(
            kind: RemoteExceptionKind.serverUndefined,
            httpErrorCode: httpErrorCode,
            rootException: exception,
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
