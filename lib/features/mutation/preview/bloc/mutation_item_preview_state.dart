import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item_preview_state.freezed.dart';

@freezed
abstract class MutationItemPreviewState extends BaseBlocState
    with _$MutationItemPreviewState {
  const factory MutationItemPreviewState({
    @Default('') String rfid,
    @Default(false) bool loading,
    @Default(false) bool isShowBottomsheet,
  }) = _MutationItemPreviewState;

  const MutationItemPreviewState._();
}
