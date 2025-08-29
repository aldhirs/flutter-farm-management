import 'package:dio/dio.dart';
import 'package:farm/constants/server/server_request_response_constants.dart';
import 'package:injectable/injectable.dart';

import '../../preference/app_preferences.dart';
import 'base_interceptor.dart';

@Injectable()
class AccessTokenInterceptor extends BaseInterceptor {
  AccessTokenInterceptor(this._appPreferences);

  final AppPreferences _appPreferences;

  @override
  int get priority => BaseInterceptor.accessTokenPriority;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = _appPreferences.getAccessToken;
    if (token?.isNotEmpty == true) {
      options.headers[ServerRequestResponseConstants.basicAuthorization] =
          "Bearer $token";
    }

    handler.next(options);
  }
}
