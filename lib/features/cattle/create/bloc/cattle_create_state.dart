import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/breed/breed.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:farm/domain/entities/reception/reception_assignee.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/entities/station/station.dart';
import 'package:farm/domain/entities/supplier/supplier.dart';
import 'package:farm/features/sales/add/model/list_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_create_state.freezed.dart';

@freezed
abstract class CattleCreateState extends BaseBlocState
    with _$CattleCreateState {
  const factory CattleCreateState({
    @Default('') String rfid,
    @Default(Sales()) Sales sale,
    @Default(UserData()) UserData userData,
    @Default(Cattle()) Cattle cattle,
    @Default([]) List<ReceptionAssignee> receptions,
    @Default([]) List<Supplier> suppliers,
    @Default([]) List<Station> stations,
    @Default([]) List<Breed> breeds,
    @Default([]) List<Level> levels,
    @Default([]) List<Barn> barns,
    @Default([]) List<Pen> pens,
    @Default(false) bool loading,
    @Default(false) bool bottomsheetLoading,
    @Default('') String errorMessage,
    @Default([]) List<ListItem> listItems,
    @Default(false) bool isSuccess,
    @Default(false) bool isFormValid,

    @Default(null) Supplier? selectedSupplier,
    @Default(null) Station? selectedStation,
    @Default(null) Reception? selectedReception,
    @Default(null) Breed? selectedBreed,
    @Default(null) Level? selectedLevel,
    @Default(null) Barn? selectedBarn,
    @Default(null) Pen? selectedPen,
    @Default(null) String? selectedGender,
    @Default(null) String? earTag,
  }) = _CattleCreateState;

  const CattleCreateState._();
}
