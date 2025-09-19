import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_preview_state.freezed.dart';

@freezed
abstract class CattlePreviewState extends BaseBlocState
    with _$CattlePreviewState {
  const factory CattlePreviewState({
    @Default('') String rfid,
    @Default(false) bool loading,
    @Default(false) bool isShowBottomsheet,
  }) = _CattlePreviewState;

  const CattlePreviewState._();
}
