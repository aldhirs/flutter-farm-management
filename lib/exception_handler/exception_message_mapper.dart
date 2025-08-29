import 'package:farm/base/exception/base/app_exception.dart';
import 'package:farm/base/exception/remote/remote_exception.dart';
import 'package:farm/extensions/string.dart';

class ExceptionMessageMapper {
  const ExceptionMessageMapper();

  String map(AppException appException) {
    switch (appException.appExceptionType) {
      case AppExceptionType.remote:
        final exception = appException as RemoteException;
        if (exception.generalServerMessage?.isNotEmpty == true) {
          return exception.generalServerMessage.defaultValue(
            exception.rootException.toString(),
          );
        }
        switch (exception.kind) {
          case RemoteExceptionKind.badCertificate:
            return 'Bad certificate';
          case RemoteExceptionKind.noInternet:
            return 'No internet connection';
          case RemoteExceptionKind.network:
            return 'Network error';
          case RemoteExceptionKind.serverDefined:
            return 'Server defined';
          case RemoteExceptionKind.serverUndefined:
            return 'Server undefined';
          case RemoteExceptionKind.timeout:
            return 'Timeout';
          case RemoteExceptionKind.cancellation:
            return 'Cancelation';
          case RemoteExceptionKind.unknown:
            return 'Unknown: ${exception.rootException}';
          case RemoteExceptionKind.refreshTokenFailed:
            return 'Token expired';
        }
      case AppExceptionType.parse:
        return 'Parse exception';
      case AppExceptionType.remoteConfig:
        return 'Remote config';
      case AppExceptionType.uncaught:
        return 'Uncaught';
      case AppExceptionType.validation:
        return 'Invalid some validation';
    }
  }
}
