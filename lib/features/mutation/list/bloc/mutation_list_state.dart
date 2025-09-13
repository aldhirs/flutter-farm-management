import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_list_state.freezed.dart';

@freezed
abstract class MutationListState extends BaseBlocState
    with _$MutationListState {
  const factory MutationListState({
    @Default('') String filterStatus,
    @Default([]) List<Mutation> items,
    @Default('') String errorMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
    @Default(false) bool isIn,
  }) = _MutationListState;
  const MutationListState._();
}
