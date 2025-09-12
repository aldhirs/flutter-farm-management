import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_event.freezed.dart';

abstract class SalesEvent extends BaseBlocEvent {
  const SalesEvent();
}

@freezed
abstract class Initiated extends SalesEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}

@freezed
abstract class FilterStatusChanged extends SalesEvent
    with _$FilterStatusChanged {
  const factory FilterStatusChanged({required String value}) =
      _FilterStatusChanged;
  const FilterStatusChanged._();
}

@freezed
abstract class LoadSales extends SalesEvent with _$LoadSales {
  const factory LoadSales({@Default(false) bool withFilter}) = _LoadSales;
  const LoadSales._();
}

@freezed
abstract class LoadMoreSales extends SalesEvent with _$LoadMoreSales {
  const factory LoadMoreSales() = _LoadMoreSales;
  const LoadMoreSales._();
}
