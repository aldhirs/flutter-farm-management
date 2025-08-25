import 'package:farm/base/exception/base/app_exception_wrapper.dart';
import 'package:farm/base/exception/remote/remote_exception.dart';
import 'package:farm/base/exception/base/app_exception.dart';
import 'package:farm/constants/duration_constants.dart';
import 'package:farm/constants/server/server_status_code_constants.dart';
import 'package:farm/helper/function/function.dart';
import 'package:farm/navigation/app_navigator.dart';

// import '../utils/app_will_pop_scope/app_will_pop_scope.dart';

class ExceptionHandler {
  const ExceptionHandler({required this.navigator, required this.listener});

  final AppNavigator navigator;
  final ExceptionHandlerListener listener;

  Future<void> handleException(
    AppExceptionWrapper appExceptionWrapper,
    String commonExceptionMessage,
  ) async {
    final message =
        appExceptionWrapper.overrideMessage ?? commonExceptionMessage;

    switch (appExceptionWrapper.appException.appExceptionType) {
      case AppExceptionType.remote:
        final exception = appExceptionWrapper.appException as RemoteException;
        switch (exception.kind) {
          case RemoteExceptionKind.refreshTokenFailed:
            await _showErrorUnauthorized();
            break;
          case RemoteExceptionKind.noInternet:
          case RemoteExceptionKind.timeout:
            await _showErrorDialogWithRetry(
              message: message,
              onRetryPressed: Func0(() async {
                await navigator.pop();
                await appExceptionWrapper.doOnRetry?.call();
              }).call,
            );
            break;
          default:
            if (exception.generalServerStatusCode ==
                ServerStatusCodeConstants.unauthorized) {
              await _showErrorUnauthorized();
            } else {
              await _showErrorDialog(message: message);
            }
            break;
        }
        break;
      case AppExceptionType.parse:
        return _showErrorSnackBar(message: message);
      case AppExceptionType.remoteConfig:
        return _showErrorSnackBar(message: message);
      case AppExceptionType.uncaught:
        return;
      case AppExceptionType.validation:
        await _showErrorDialog(message: message);
        break;
    }
  }

  void _showErrorSnackBar({
    required String message,
    Duration duration = DurationConstants.defaultErrorVisibleDuration,
  }) {
    // navigator.showErrorSnackBar(message, duration: duration);
  }

  Future<void> _showErrorDialog({
    required String message,
    Func0<void>? onPressed,
    bool isRefreshTokenFailed = false,
  }) async {
    // await navigator
    //     .showDialog(
    //       AppPopupInfo.confirmDialog(message: message, onPressed: onPressed),
    //     )
    //     .then((value) {
    //       if (isRefreshTokenFailed) {
    //         listener.onRefreshTokenFailed();
    //       }
    //     });
  }

  Future<void> _showErrorUnauthorized() async {
    // await navigator.showAppDialog(
    //   useRootNavigator: true,
    //   barrierDismissible: false,
    //   Popup(
    //     title: S.current.unauthorized_title,
    //     description: [TextSpan(text: S.current.unauthorized_desc)],
    //     positiveButtonText: S.current.understand,
    //     illustration: Assets.images.ilUnauthorized.svg(width: Dimens.d180),
    //     onPositiveButtonPressed: () async {
    //       listener.onRefreshTokenFailed();
    //     },
    //   ),
    // );
  }

  Future<void> _showErrorDialogWithRetry({
    required String message,
    required Function() onRetryPressed,
  }) async {}
}

abstract class ExceptionHandlerListener {
  void onRefreshTokenFailed();
}
