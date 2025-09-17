import 'package:dartx/dartx.dart';
import 'package:farm/domain/entities/auth/login_request.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/breed/breed.dart';
import 'package:farm/domain/entities/breed/breed_request.dart';
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
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/domain/entities/mutation/mutation_item.dart';
import 'package:farm/domain/entities/mutation/mutation_item_add_request.dart';
import 'package:farm/domain/entities/mutation/mutation_item_delete_request.dart';
import 'package:farm/domain/entities/mutation/mutation_item_request.dart';
import 'package:farm/domain/entities/mutation/mutation_request.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:farm/domain/entities/project/project_request.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:farm/domain/entities/reception/reception_request.dart';
import 'package:farm/domain/entities/sales/sale_id_request.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:farm/domain/entities/sales/sales_item_add_request.dart';
import 'package:farm/domain/entities/sales/sales_item_delete_request.dart';
import 'package:farm/domain/entities/sales/sales_item_move_request.dart';
import 'package:farm/domain/entities/sales/sales_item_request.dart';
import 'package:farm/domain/entities/sales/sales_item_save_request.dart';
import 'package:farm/domain/entities/sales/sales_request.dart';
import 'package:farm/domain/entities/supplier/supplier.dart';
import 'package:farm/domain/entities/supplier/supplier_request.dart';
import 'package:farm/domain/entities/treatment/treatment_form_request.dart';
import 'package:farm/domain/entities/treatment/treatment_type.dart';
import 'package:farm/domain/entities/treatment/treatment_type_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/domain/repositories/source/api/api_service.dart';
import 'package:farm/domain/repositories/source/preference/app_preferences.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: Repository)
class RepositoryImpl implements Repository {
  RepositoryImpl(this._apiService, this._appPreferences);

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
  Future<DataListResponse<Cattle>> cattles(CattleListRequest request) async {
    final response = await _apiService.cattles(request);
    return response;
  }

  @override
  Future<DataResponse<Cattle>> cattleByRFID(CattleRequest request) async {
    final response = await _apiService.cattleByRFID(request);
    return response;
  }

  @override
  Future<DataResponse<Cattle>> cattleByEarTag(CattleRequest request) async {
    final response = await _apiService.cattleByEarTag(request);
    return response;
  }

  @override
  Future<DataResponse<void>> cattleMovePenToPen(
    CattlePenToPenRequest request,
  ) async {
    final response = await _apiService.cattleMovePenToPen(request);
    return response;
  }

  @override
  Future<DataResponse<Cattle>> cattleCreate(CattleFormRequest request) async {
    final response = await _apiService.cattleCreate(request);
    return response;
  }

  @override
  Future<DataResponse<void>> cattleUpdate(CattleFormRequest request) async {
    final response = await _apiService.cattleUpdate(request);
    return response;
  }

  @override
  Future<DataResponse<Growth>> growthCreate(GrowthFormRequest request) async {
    final response = await _apiService.growthCreate(request);
    return response;
  }

  @override
  Future<DataResponse<void>> growthUpdate(GrowthFormRequest request) async {
    final response = await _apiService.growthUpdate(request);
    return response;
  }

  @override
  Future<DataResponse<void>> treatmentCreate(
    TreatmentFormRequest request,
  ) async {
    final response = await _apiService.treatmentCreate(request);
    return response;
  }

  @override
  Future<DataResponse<void>> medicalCreate(MedicalFormRequest request) async {
    final response = await _apiService.medicalCreate(request);
    return response;
  }

  @override
  Future<DataListResponse<Project>> projects(ProjectRequest request) async {
    final response = await _apiService.projects(request);
    return response;
  }

  @override
  Future<DataListResponse<Barn>> barns(BarnRequest request) async {
    final response = await _apiService.barns(request);
    return response;
  }

  @override
  Future<DataListResponse<Pen>> pens(PenRequest request) async {
    final response = await _apiService.pens(request);
    return response;
  }

  @override
  Future<DataListResponse<MedicalType>> medicalTypes(
    MedicalTypeRequest request,
  ) async {
    final response = await _apiService.medicalTypes(request);
    return response;
  }

  @override
  Future<DataListResponse<TreatmentType>> treatmentTypes(
    TreatmentTypeRequest request,
  ) async {
    final response = await _apiService.treatmentTypes(request);
    return response;
  }

  @override
  Future<DataListResponse<Level>> levels(LevelRequest request) async {
    final response = await _apiService.levels(request);
    return response;
  }

  @override
  Future<DataListResponse<Breed>> breeds(BreedRequest request) async {
    final response = await _apiService.breeds(request);
    return response;
  }

  @override
  Future<DataListResponse<Supplier>> suppliers(SupplierRequest request) async {
    final response = await _apiService.suppliers(request);
    return response;
  }

  @override
  Future<DataListResponse<Reception>> receptions(
    ReceptionRequest request,
  ) async {
    final response = await _apiService.receptions(request);
    return response;
  }

  @override
  Future<DataListResponse<Sales>> sales(SalesRequest request) async {
    final response = await _apiService.sales(request);
    return response;
  }

  @override
  Future<DataResponse<Sales>> saleByID(SaleIdRequest request) async {
    final response = await _apiService.saleByID(request);
    return response;
  }

  @override
  Future<DataListResponse<SalesItem>> salesItems(
    SalesItemRequest request,
  ) async {
    final response = await _apiService.salesItems(request);
    return response;
  }

  @override
  Future<DataResponse<void>> salesItemSave(SalesItemSaveRequest request) async {
    final response = await _apiService.salesItemSave(request);
    return response;
  }

  @override
  Future<DataResponse<void>> salesItemAdd(SalesItemAddRequest request) async {
    final response = await _apiService.salesItemAdd(request);
    return response;
  }

  @override
  Future<DataResponse<void>> salesItemDelete(
    SalesItemDeleteRequest request,
  ) async {
    final response = await _apiService.salesItemDelete(request);
    return response;
  }

  @override
  Future<DataResponse<void>> salesItemMove(SalesItemMoveRequest request) async {
    final response = await _apiService.salesItemMove(request);
    return response;
  }

  @override
  Future<DataListResponse<Mutation>> mutations(MutationRequest request) async {
    final response = await _apiService.mutations(request);
    return response;
  }

  @override
  Future<DataListResponse<MutationItem>> mutationItems(
    MutationItemRequest request,
  ) async {
    final response = await _apiService.mutationItems(request);
    return response;
  }

  @override
  Future<DataResponse<void>> mutationItemAdd(
    MutationItemAddRequest request,
  ) async {
    final response = await _apiService.mutationItemAdd(request);
    return response;
  }

  @override
  Future<DataResponse<void>> mutationItemDelete(
    MutationItemDeleteRequest request,
  ) async {
    final response = await _apiService.mutationItemDelete(request);
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
