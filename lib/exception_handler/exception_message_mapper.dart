import 'package:farm/base/exception/base/app_exception.dart';
import 'package:farm/base/exception/remote/remote_exception.dart';

class ExceptionMessageMapper {
  const ExceptionMessageMapper();

  String map(AppException appException) {
    switch (appException.appExceptionType) {
      case AppExceptionType.remote:
        final exception = appException as RemoteException;
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
      //   final exception = appException as ValidationException;
      // switch (exception.kind) {
      //   case ValidationExceptionKind.emptyEmail:
      //     return 'Invalid email';
      //   case ValidationExceptionKind.invalidEmail:
      //     return S.current.invalid_email;
      //   case ValidationExceptionKind.invalidPassword:
      //     return S.current.invalid_password;
      //   case ValidationExceptionKind.invalidUserName:
      //     return S.current.invalid_user_name;
      //   case ValidationExceptionKind.invalidPhoneNumber:
      //     return S.current.invalid_phone_number;
      //   case ValidationExceptionKind.invalidDateTime:
      //     return S.current.invalid_date_time;
      //   case ValidationExceptionKind.passwordsAreNotMatch:
      //     return S.current.passwords_are_not_match;
      // }
    }
  }

  bool isNoInternet(AppException appException) {
    if (appException.appExceptionType == AppExceptionType.remote) {
      final exception = appException as RemoteException;
      return exception.kind == RemoteExceptionKind.noInternet;
    }
    return false;
  }

  bool isCantConnectHost(AppException appException) {
    if (appException.appExceptionType == AppExceptionType.remote) {
      final exception = appException as RemoteException;
      return exception.kind == RemoteExceptionKind.network;
    }
    return false;
  }
}
