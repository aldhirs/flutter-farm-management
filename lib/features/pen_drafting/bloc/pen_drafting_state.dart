import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pen_drafting_state.freezed.dart';

@freezed
abstract class PenDraftingState extends BaseBlocState with _$PenDraftingState {
  const factory PenDraftingState({
    @Default('') String filterStatus,
    @Default([]) List<Pen> items,
    @Default([]) List<Barn> barns,
    @Default([]) List<Pen> dropdownPens,
    @Default(null) Barn? selectedBarn,
    @Default(null) Pen? selectedPen,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default('') String errorSnackMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
    @Default(false) bool loading,
  }) = _PenDraftingState;
  const PenDraftingState._();
}
