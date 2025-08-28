import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_detail_state.freezed.dart';

@freezed
abstract class DraftingDetailState extends BaseBlocState
    with _$DraftingDetailState {
  const factory DraftingDetailState({
    @Default('') String rfid,
    @Default(false) bool loading,
    @Default(false) bool isShowBottomsheet,
  }) = _DraftingDetailState;

  const DraftingDetailState._();
}
