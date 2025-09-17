import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pen_drafting_event.freezed.dart';

abstract class PenDraftingEvent extends BaseBlocEvent {
  const PenDraftingEvent();
}

@freezed
abstract class Initiated extends PenDraftingEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}

@freezed
abstract class FilterStatusChanged extends PenDraftingEvent
    with _$FilterStatusChanged {
  const factory FilterStatusChanged({required String value}) =
      _FilterStatusChanged;
  const FilterStatusChanged._();
}

@freezed
abstract class ResetBottomsheet extends PenDraftingEvent
    with _$ResetBottomsheet {
  const factory ResetBottomsheet() = _ResetBottomsheet;
  const ResetBottomsheet._();
}

@freezed
abstract class Load extends PenDraftingEvent with _$Load {
  const factory Load({@Default(false) bool withFilter}) = _Load;
  const Load._();
}

@freezed
abstract class OnSubmitMoveToPen extends PenDraftingEvent
    with _$OnSubmitMoveToPen {
  const factory OnSubmitMoveToPen({required Pen fromPen}) = _OnSubmitMoveToPen;
  const OnSubmitMoveToPen._();
}

@freezed
abstract class LoadMore extends PenDraftingEvent with _$LoadMore {
  const factory LoadMore() = _LoadMore;
  const LoadMore._();
}

@freezed
abstract class GetBarns extends PenDraftingEvent with _$GetBarns {
  const factory GetBarns({String? search}) = _GetBarns;

  const GetBarns._();
}

@freezed
abstract class BarnChanged extends PenDraftingEvent with _$BarnChanged {
  const factory BarnChanged({required Barn barn}) = _BarnChanged;

  const BarnChanged._();
}

@freezed
abstract class GetPens extends PenDraftingEvent with _$GetPens {
  const factory GetPens({required String barnId}) = _GetPens;

  const GetPens._();
}

@freezed
abstract class PenChanged extends PenDraftingEvent with _$PenChanged {
  const factory PenChanged({required Pen pen}) = _PenChanged;

  const PenChanged._();
}
