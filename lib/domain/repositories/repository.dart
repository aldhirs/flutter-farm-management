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

abstract class Repository {
  bool get isLoggedIn;
  Future<DataResponse<UserData>> login(LoginRequest request);
  Future<DataListResponse<Project>> projects(ProjectRequest request);
  Future<DataListResponse<Barn>> barns(BarnRequest request);
  Future<DataListResponse<Pen>> pens(PenRequest request);
  Future<DataListResponse<Level>> levels(LevelRequest request);

  Future<DataResponse<Cattle>> cattleByRFID(CattleRequest request);
  Future<DataResponse<void>> cattleUpdate(CattleFormRequest request);

  Future<void> logout();
  UserData getUserDataPreference();
  String getUserToken();
}
