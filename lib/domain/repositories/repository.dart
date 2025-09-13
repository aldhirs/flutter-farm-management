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
import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:farm/domain/entities/project/project_request.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:farm/domain/entities/reception/reception_request.dart';
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

abstract class Repository {
  bool get isLoggedIn;
  Future<DataResponse<UserData>> login(LoginRequest request);
  Future<DataListResponse<Project>> projects(ProjectRequest request);
  Future<DataListResponse<Barn>> barns(BarnRequest request);
  Future<DataListResponse<Pen>> pens(PenRequest request);
  Future<DataListResponse<Level>> levels(LevelRequest request);
  Future<DataListResponse<Breed>> breeds(BreedRequest request);
  Future<DataListResponse<Supplier>> suppliers(SupplierRequest request);
  Future<DataListResponse<Reception>> receptions(ReceptionRequest request);
  Future<DataListResponse<TreatmentType>> treatmentTypes(
    TreatmentTypeRequest request,
  );
  Future<DataListResponse<MedicalType>> medicalTypes(
    MedicalTypeRequest request,
  );

  Future<DataListResponse<Cattle>> cattles(CattleListRequest request);
  Future<DataResponse<Cattle>> cattleByRFID(CattleRequest request);
  Future<DataResponse<Cattle>> cattleByEarTag(CattleRequest request);
  Future<DataResponse<Cattle>> cattleCreate(CattleFormRequest request);
  Future<DataResponse<void>> cattleUpdate(CattleFormRequest request);
  Future<DataResponse<void>> cattleMovePenToPen(CattlePenToPenRequest request);
  Future<DataResponse<Growth>> growthCreate(GrowthFormRequest request);
  Future<DataResponse<void>> growthUpdate(GrowthFormRequest request);
  Future<DataResponse<void>> treatmentCreate(TreatmentFormRequest request);
  Future<DataResponse<void>> medicalCreate(MedicalFormRequest request);

  Future<DataListResponse<Sales>> sales(SalesRequest request);
  Future<DataListResponse<SalesItem>> salesItems(SalesItemRequest request);
  Future<DataResponse<void>> salesItemSave(SalesItemSaveRequest request);
  Future<DataResponse<void>> salesItemAdd(SalesItemAddRequest request);
  Future<DataResponse<void>> salesItemDelete(SalesItemDeleteRequest request);
  Future<DataResponse<void>> salesItemMove(SalesItemMoveRequest request);

  Future<void> logout();
  UserData getUserDataPreference();
  String getUserToken();
}
