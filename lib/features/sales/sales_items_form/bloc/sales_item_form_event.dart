import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_form_event.freezed.dart';

abstract class SalesItemFormEvent extends BaseBlocEvent {
  const SalesItemFormEvent();
}

@freezed
abstract class Initiated extends SalesItemFormEvent with _$Initiated {
  const factory Initiated({required Sales item}) = _Initiated;
  const Initiated._();
}

@freezed
abstract class OnSearch extends SalesItemFormEvent with _$OnSearch {
  const factory OnSearch() = _OnSearch;
  const OnSearch._();
}

@freezed
abstract class Load extends SalesItemFormEvent with _$Load {
  const factory Load({@Default(false) bool withFilter}) = _Load;
  const Load._();
}

@freezed
abstract class LoadMore extends SalesItemFormEvent with _$LoadMore {
  const factory LoadMore() = _LoadMore;
  const LoadMore._();
}

@freezed
abstract class GetPens extends SalesItemFormEvent with _$GetPens {
  const factory GetPens({required String barnId}) = _GetPens;

  const GetPens._();
}

@freezed
abstract class BarnChanged extends SalesItemFormEvent with _$BarnChanged {
  const factory BarnChanged({required Barn barn}) = _BarnChanged;

  const BarnChanged._();
}

@freezed
abstract class PenChanged extends SalesItemFormEvent with _$PenChanged {
  const factory PenChanged({required Pen pen}) = _PenChanged;

  const PenChanged._();
}

@freezed
abstract class SelectedItemChanged extends SalesItemFormEvent
    with _$SelectedItemChanged {
  const factory SelectedItemChanged({required Cattle cattle}) =
      _SelectedItemChanged;

  const SelectedItemChanged._();
}

@freezed
abstract class OnSubmit extends SalesItemFormEvent with _$OnSubmit {
  const factory OnSubmit() = _OnSubmit;

  const OnSubmit._();
}

@freezed
abstract class OnClearMessage extends SalesItemFormEvent with _$OnClearMessage {
  const factory OnClearMessage() = _OnClearMessage;

  const OnClearMessage._();
}
