import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/auth/login_request.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/cattle/cattle_form_request.dart';
import 'package:farm/domain/entities/cattle/cattle_list_request.dart';
import 'package:farm/domain/entities/cattle/cattle_pen_to_pen_request.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/growth/growth.dart';
import 'package:farm/domain/entities/growth/growth_form_request.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/level/level_request.dart';
import 'package:farm/domain/entities/medical/medical_form_request.dart';
import 'package:farm/domain/entities/medical/medical_type.dart';
import 'package:farm/domain/entities/medical/medical_type_request.dart';
import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:farm/domain/entities/project/project_request.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:farm/domain/entities/sales/sales_item_delete_request.dart';
import 'package:farm/domain/entities/sales/sales_item_move_request.dart';
import 'package:farm/domain/entities/sales/sales_item_request.dart';
import 'package:farm/domain/entities/sales/sales_item_save_request.dart';
import 'package:farm/domain/entities/sales/sales_request.dart';
import 'package:farm/domain/entities/treatment/treatment_form_request.dart';
import 'package:farm/domain/entities/treatment/treatment_type.dart';
import 'package:farm/domain/entities/treatment/treatment_type_request.dart';
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

  Future<DataListResponse<Cattle>> cattles(CattleListRequest request) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/cattle',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: Cattle.fromJson,
    );
  }

  Future<DataResponse<void>> cattleMovePenToPen(
    CattlePenToPenRequest request,
  ) async {
    return _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/cattle/move-pen-to-pen',
      body: request.toJson(),
      decoder: (_) => null,
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

  Future<DataListResponse<TreatmentType>> treatmentTypes(
    TreatmentTypeRequest request,
  ) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/treatment/type',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: TreatmentType.fromJson,
    );
  }

  Future<DataListResponse<MedicalType>> medicalTypes(
    MedicalTypeRequest request,
  ) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/medical/type',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: MedicalType.fromJson,
    );
  }

  Future<DataResponse<Growth>> growthCreate(GrowthFormRequest request) async {
    const Map<String, dynamic> queryParameters = {};
    return _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/growth',
      queryParameters: queryParameters,
      body: request.toJson(),
      decoder: Growth.fromJson,
    );
  }

  Future<DataResponse<void>> growthUpdate(GrowthFormRequest request) async {
    const Map<String, dynamic> queryParameters = {};
    return _authAppServerApiClient.request(
      method: RestMethod.put,
      path: '/v1/growth',
      queryParameters: queryParameters,
      body: request.toJson(),
      decoder: (_) => null,
    );
  }

  Future<DataResponse<void>> treatmentCreate(
    TreatmentFormRequest request,
  ) async {
    const Map<String, dynamic> queryParameters = {};
    return _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/treatment',
      queryParameters: queryParameters,
      body: request.toJson(),
      decoder: (_) => null,
    );
  }

  Future<DataResponse<void>> medicalCreate(MedicalFormRequest request) async {
    const Map<String, dynamic> queryParameters = {};
    return _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/medical',
      queryParameters: queryParameters,
      body: request.toJson(),
      decoder: (_) => null,
    );
  }

  Future<DataListResponse<Sales>> sales(SalesRequest request) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/sales',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: Sales.fromJson,
    );
  }

  Future<DataListResponse<SalesItem>> salesItems(
    SalesItemRequest request,
  ) async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/sales-item',
      queryParameters: request.toJson(),
      successResponseMapperType: SuccessResponseMapperType.dataJsonArray,
      decoder: SalesItem.fromJson,
    );
  }

  Future<DataResponse<void>> salesItemSave(SalesItemSaveRequest request) async {
    return _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/sales-item/bulk-create',
      body: request.toJson(),
      decoder: (_) => null,
    );
  }

  Future<DataResponse<void>> salesItemDelete(
    SalesItemDeleteRequest request,
  ) async {
    return _authAppServerApiClient.request(
      method: RestMethod.delete,
      path: '/v1/sales-item',
      body: request.toJson(),
      decoder: (_) => null,
    );
  }

  Future<DataResponse<void>> salesItemMove(SalesItemMoveRequest request) async {
    return _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/sales-item/refer',
      body: request.toJson(),
      decoder: (_) => null,
    );
  }
}
