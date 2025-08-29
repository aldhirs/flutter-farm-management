import 'package:farm/constants/url_constants.dart';
import 'package:farm/domain/repositories/source/source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthAppServerApiClient extends RestApiClient {
  AuthAppServerApiClient(AccessTokenInterceptor _accessTokenInterceptor)
    : super(
        baseUrl: UrlConstants.appBaseUrl,
        interceptors: [_accessTokenInterceptor],
      );
}
