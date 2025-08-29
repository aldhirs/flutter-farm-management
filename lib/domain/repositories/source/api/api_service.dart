import 'package:farm/domain/entities/auth/login_request.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/domain/repositories/source/source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ApiService {
  ApiService(this._noneAuthAppServerApiClient, this._authAppServerApiClient);

  final NoneAuthAppServerApiClient _noneAuthAppServerApiClient;
  final AuthAppServerApiClient _authAppServerApiClient;

  Future<DataResponse<UserData>> login(LoginRequest request) async {
    const Map<String, dynamic> queryParameters = {};
    return _noneAuthAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/public/auth/login',
      queryParameters: queryParameters,
      body: request.toJson(),
      decoder: UserData.fromJson,
    );
  }
}
