import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/entities/sales/sales_item.dart';
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

@freezed
abstract class EditModeToggled extends SalesItemsEvent with _$EditModeToggled {
  const factory EditModeToggled() = _EditModeToggled;
  const EditModeToggled._();
}

@freezed
abstract class ItemSelectionToggled extends SalesItemsEvent
    with _$ItemSelectionToggled {
  const factory ItemSelectionToggled({required SalesItem item}) =
      _ItemSelectionToggled;
  const ItemSelectionToggled._();
}

@freezed
abstract class DeleteSalesItems extends SalesItemsEvent
    with _$DeleteSalesItems {
  const factory DeleteSalesItems({required List<SalesItem> items}) =
      _DeleteSalesItems;
  const DeleteSalesItems._();
}
