import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_list_event.freezed.dart';

abstract class MutationListEvent extends BaseBlocEvent {
  const MutationListEvent();
}

@freezed
abstract class Initiated extends MutationListEvent with _$Initiated {
  const factory Initiated({required bool isIn}) = _Initiated;
  const Initiated._();
}

@freezed
abstract class FilterStatusChanged extends MutationListEvent
    with _$FilterStatusChanged {
  const factory FilterStatusChanged({required String value}) =
      _FilterStatusChanged;
  const FilterStatusChanged._();
}

@freezed
abstract class LoadMutationList extends MutationListEvent
    with _$LoadMutationList {
  const factory LoadMutationList({@Default(false) bool withFilter}) =
      _LoadMutationList;
  const LoadMutationList._();
}

@freezed
abstract class LoadMoreMutationList extends MutationListEvent
    with _$LoadMoreMutationList {
  const factory LoadMoreMutationList() = _LoadMoreMutationList;
  const LoadMoreMutationList._();
}
