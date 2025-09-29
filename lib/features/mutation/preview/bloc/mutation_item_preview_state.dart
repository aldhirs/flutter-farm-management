import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item_preview_state.freezed.dart';

@freezed
abstract class MutationItemPreviewState extends BaseBlocState
    with _$MutationItemPreviewState {
  const factory MutationItemPreviewState({
    @Default('') String rfid,
    @Default(Mutation()) Mutation mutation,
    @Default(null) Cattle? cattle,
    @Default(false) bool loading,
    @Default('') String errorMessage,
    @Default('') String cattleErrorMessage,
    @Default(false) bool isSuccessAdd,
  }) = _MutationItemPreviewState;

  const MutationItemPreviewState._();
}
