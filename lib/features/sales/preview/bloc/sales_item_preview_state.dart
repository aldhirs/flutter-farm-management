import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_preview_state.freezed.dart';

@freezed
abstract class SalesItemPreviewState extends BaseBlocState
    with _$SalesItemPreviewState {
  const factory SalesItemPreviewState({
    @Default('') String rfid,
    @Default(false) bool loading,
    @Default(false) bool isShowBottomsheet,
  }) = _SalesItemPreviewState;

  const SalesItemPreviewState._();
}
