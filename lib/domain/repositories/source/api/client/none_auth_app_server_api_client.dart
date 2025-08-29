import 'package:farm/constants/url_constants.dart';
import 'package:farm/domain/repositories/source/source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class NoneAuthAppServerApiClient extends RestApiClient {
  NoneAuthAppServerApiClient()
    : super(baseUrl: UrlConstants.appBaseUrl, interceptors: []);
}
