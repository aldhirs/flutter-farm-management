import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_form_state.freezed.dart';

@freezed
abstract class DraftingFormState extends BaseBlocState
    with _$DraftingFormState {
  const factory DraftingFormState({
    @Default('') String rfid,
    @Default(false) bool loading,
  }) = _DraftingFormState;

  const DraftingFormState._();
}
