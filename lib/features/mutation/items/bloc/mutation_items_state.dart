import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/domain/entities/mutation/mutation_item.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_items_state.freezed.dart';

@freezed
abstract class MutationItemsState extends BaseBlocState
    with _$MutationItemsState {
  const factory MutationItemsState({
    @Default(Mutation()) Mutation mutation,
    @Default([]) List<MutationItem> mutationItems,
    @Default([]) List<Mutation> mutationList,
    @Default('') String errorMessage,
    @Default('') String earTagErrorMessage,
    @Default(false) bool earTagLoading,
    @Default('') String earTag,
    @Default(null) Cattle? cattle,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
    @Default(false) bool isEditMode,
    @Default('') String successMessage,
    @Default([]) List<MutationItem> selectedItems,
    @Default([]) List<Barn> barns,
    @Default([]) List<Pen> pens,
    @Default(false) bool loading,
    @Default(null) Barn? selectedBarn,
    @Default(null) Pen? selectedPen,
    @Default(null) Mutation? selectedSale,
  }) = _MutationItemsState;
  const MutationItemsState._();
}
