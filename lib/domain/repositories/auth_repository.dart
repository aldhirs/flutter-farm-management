import 'package:farm/domain/entities/auth/login_request.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/model/data_response.dart';

abstract class AuthRepository {
  bool get isLoggedIn;

  Future<DataResponse<UserData>> login(LoginRequest request);

  Future<void> logout();

  UserData getUserDataPreference();

  String getUserToken();
}
