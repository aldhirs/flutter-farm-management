import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/features/drafting/form/model/list_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_form_state.freezed.dart';

@freezed
abstract class DraftingFormState extends BaseBlocState
    with _$DraftingFormState {
  const factory DraftingFormState({
    @Default('') String rfid,
    @Default(UserData()) UserData userData,
    @Default(Cattle()) Cattle cattle,
    @Default([]) List<Barn> barns,
    @Default([]) List<Pen> pens,
    @Default([]) List<Level> levels,
    @Default(null) Barn? selectedBarn,
    @Default(null) Pen? selectedPen,
    @Default(null) String? earTag,
    @Default(null) Level? selectedLevel,
    @Default(false) bool loading,
    @Default(false) bool bottomsheetLoading,
    @Default('') String errorMessage,
    @Default([]) List<ListItem> listItems,
    @Default(false) bool isIdentitySuccess,
    @Default(false) bool isGrowthSuccess,
    @Default(false) bool isTreatmentSuccess,
    @Default(false) bool isMedicSuccess,

    @Default(false) bool isLevelError,
    @Default('') String identityErrorMessage,
  }) = _DraftingFormState;

  const DraftingFormState._();
}
