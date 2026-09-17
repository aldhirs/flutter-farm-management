import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_list_event.freezed.dart';

abstract class DraftingListEvent extends BaseBlocEvent {
  const DraftingListEvent();
}

@freezed
abstract class Initiated extends DraftingListEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}

@freezed
abstract class Refreshed extends DraftingListEvent with _$Refreshed {
  const factory Refreshed() = _Refreshed;
  const Refreshed._();
}

@freezed
abstract class LoadMore extends DraftingListEvent with _$LoadMore {
  const factory LoadMore() = _LoadMore;
  const LoadMore._();
}
