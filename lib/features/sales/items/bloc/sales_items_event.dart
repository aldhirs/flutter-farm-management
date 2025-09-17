import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/pen/pen.dart';
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

@freezed
abstract class SalesList extends SalesItemsEvent with _$SalesList {
  const factory SalesList() = _SalesList;

  const SalesList._();
}

@freezed
abstract class SaleByID extends SalesItemsEvent with _$SaleByID {
  const factory SaleByID() = _SaleByID;

  const SaleByID._();
}

@freezed
abstract class GetBarns extends SalesItemsEvent with _$GetBarns {
  const factory GetBarns() = _GetBarns;

  const GetBarns._();
}

@freezed
abstract class BarnChanged extends SalesItemsEvent with _$BarnChanged {
  const factory BarnChanged({required Barn barn}) = _BarnChanged;

  const BarnChanged._();
}

@freezed
abstract class GetPens extends SalesItemsEvent with _$GetPens {
  const factory GetPens({required String barnId}) = _GetPens;

  const GetPens._();
}

@freezed
abstract class PenChanged extends SalesItemsEvent with _$PenChanged {
  const factory PenChanged({required Pen pen}) = _PenChanged;

  const PenChanged._();
}

@freezed
abstract class SaleChanged extends SalesItemsEvent with _$SaleChanged {
  const factory SaleChanged({required Sales sale}) = _SaleChanged;

  const SaleChanged._();
}

@freezed
abstract class OnSubmitMoveSale extends SalesItemsEvent
    with _$OnSubmitMoveSale {
  const factory OnSubmitMoveSale({required List<SalesItem> items}) =
      _OnSubmitMoveSale;
  const OnSubmitMoveSale._();
}

@freezed
abstract class EarTagChanged extends SalesItemsEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}

@freezed
abstract class CheckCattleEarTag extends SalesItemsEvent
    with _$CheckCattleEarTag {
  const factory CheckCattleEarTag() = _CheckCattleEarTag;

  const CheckCattleEarTag._();
}
