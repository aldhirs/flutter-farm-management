import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_nav_bar_event.freezed.dart';

abstract class MutationNavBarEvent extends BaseBlocEvent {
  const MutationNavBarEvent();
}

@freezed
abstract class Initiated extends MutationNavBarEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}
