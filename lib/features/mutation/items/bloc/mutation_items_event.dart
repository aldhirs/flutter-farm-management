import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/domain/entities/mutation/mutation_item.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_items_event.freezed.dart';

abstract class MutationItemsEvent extends BaseBlocEvent {
  const MutationItemsEvent();
}

@freezed
abstract class Initiated extends MutationItemsEvent with _$Initiated {
  const factory Initiated({required Mutation item}) = _Initiated;
  const Initiated._();
}

@freezed
abstract class FilterStatusChanged extends MutationItemsEvent
    with _$FilterStatusChanged {
  const factory FilterStatusChanged({required String value}) =
      _FilterStatusChanged;
  const FilterStatusChanged._();
}

@freezed
abstract class Load extends MutationItemsEvent with _$Load {
  const factory Load({@Default(false) bool withFilter}) = _Load;
  const Load._();
}

@freezed
abstract class LoadMore extends MutationItemsEvent with _$LoadMore {
  const factory LoadMore() = _LoadMore;
  const LoadMore._();
}

@freezed
abstract class EditModeToggled extends MutationItemsEvent
    with _$EditModeToggled {
  const factory EditModeToggled() = _EditModeToggled;
  const EditModeToggled._();
}

@freezed
abstract class ItemSelectionToggled extends MutationItemsEvent
    with _$ItemSelectionToggled {
  const factory ItemSelectionToggled({required MutationItem item}) =
      _ItemSelectionToggled;
  const ItemSelectionToggled._();
}

@freezed
abstract class DeleteMutationItems extends MutationItemsEvent
    with _$DeleteMutationItems {
  const factory DeleteMutationItems({required List<MutationItem> items}) =
      _DeleteMutationItems;
  const DeleteMutationItems._();
}

@freezed
abstract class GetBarns extends MutationItemsEvent with _$GetBarns {
  const factory GetBarns() = _GetBarns;

  const GetBarns._();
}

@freezed
abstract class BarnChanged extends MutationItemsEvent with _$BarnChanged {
  const factory BarnChanged({required Barn barn}) = _BarnChanged;

  const BarnChanged._();
}

@freezed
abstract class GetPens extends MutationItemsEvent with _$GetPens {
  const factory GetPens({required String barnId}) = _GetPens;

  const GetPens._();
}

@freezed
abstract class PenChanged extends MutationItemsEvent with _$PenChanged {
  const factory PenChanged({required Pen pen}) = _PenChanged;

  const PenChanged._();
}

@freezed
abstract class SaleChanged extends MutationItemsEvent with _$SaleChanged {
  const factory SaleChanged({required Mutation sale}) = _SaleChanged;

  const SaleChanged._();
}

@freezed
abstract class EarTagChanged extends MutationItemsEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}

@freezed
abstract class CheckCattleEarTag extends MutationItemsEvent
    with _$CheckCattleEarTag {
  const factory CheckCattleEarTag() = _CheckCattleEarTag;

  const CheckCattleEarTag._();
}
