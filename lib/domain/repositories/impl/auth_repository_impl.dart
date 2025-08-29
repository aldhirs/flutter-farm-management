import 'package:dartx/dartx.dart';
import 'package:farm/domain/entities/auth/login_request.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/repositories/auth_repository.dart';
import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/domain/repositories/source/api/api_service.dart';
import 'package:farm/domain/repositories/source/preference/app_preferences.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._apiService, this._appPreferences);

  final ApiService _apiService;
  final AppPreferences _appPreferences;

  @override
  bool get isLoggedIn => _appPreferences.getAccessToken?.isNotEmpty == true;

  @override
  Future<DataResponse<UserData>> login(LoginRequest request) async {
    final response = await _apiService.login(request);
    await _saveUserAndToken(response.data);
    return response;
  }

  @override
  UserData getUserDataPreference() =>
      _appPreferences.userData ?? const UserData();

  @override
  Future<void> logout() async {
    // TODO
    // await _authApiService.logout(request);
    await _appPreferences.clearCurrentUserData();
  }

  @override
  String getUserToken() => _appPreferences.getAccessToken.orEmpty();

  // save user and token to shared preference after login success
  Future<List<dynamic>> _saveUserAndToken(UserData? data) async {
    return Future.wait([
      _appPreferences.saveUserData(data ?? const UserData()),
      if (data != null && data.token.isNotEmpty)
        _appPreferences.saveAccessToken(data.token),
    ]);
  }
}
