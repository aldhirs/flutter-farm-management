import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/auth/login_request.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/cattle/cattle_form_request.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/general/empty_response.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/level/level_request.dart';
import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:farm/domain/entities/project/project_request.dart';
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

  Future<DataResponse<Cattle>> cattleByRFID(CattleRequest request) async {
    const Map<String, dynamic> queryParameters = {};
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/cattle/rfid/${request.rfid}',
      queryParameters: queryParameters,
      decoder: Cattle.fromJson,
    );
  }

  Future<DataResponse<void>> cattleUpdate(CattleFormRequest request) async {
    const Map<String, dynamic> queryParameters = {};
    return _authAppServerApiClient.request(
      method: RestMethod.put,
      path: '/v1/cattle',
      queryParameters: queryParameters,
      body: request.toJson(),
      decoder: (_) => null,
    );
  }

  Future<DataListResponse<Project>> projects(ProjectRequest request) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/project',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: Project.fromJson,
    );
  }

  Future<DataListResponse<Barn>> barns(BarnRequest request) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/barn',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: Barn.fromJson,
    );
  }

  Future<DataListResponse<Pen>> pens(PenRequest request) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/pen',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: Pen.fromJson,
    );
  }

  Future<DataListResponse<Level>> levels(LevelRequest request) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/level',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: Level.fromJson,
    );
  }
}
