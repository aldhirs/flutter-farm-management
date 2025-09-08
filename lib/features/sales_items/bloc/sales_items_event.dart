import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_items_event.freezed.dart';

abstract class SalesItemsEvent extends BaseBlocEvent {
  const SalesItemsEvent();
}

@freezed
abstract class Initiated extends SalesItemsEvent with _$Initiated {
  const factory Initiated({required Sales item}) = _Initiated;
  const Initiated._();
}

@freezed
abstract class FilterStatusChanged extends SalesItemsEvent
    with _$FilterStatusChanged {
  const factory FilterStatusChanged({required String value}) =
      _FilterStatusChanged;
  const FilterStatusChanged._();
}

@freezed
abstract class Load extends SalesItemsEvent with _$Load {
  const factory Load({@Default(false) bool withFilter}) = _Load;
  const Load._();
}

@freezed
abstract class LoadMore extends SalesItemsEvent with _$LoadMore {
  const factory LoadMore() = _LoadMore;
  const LoadMore._();
}
