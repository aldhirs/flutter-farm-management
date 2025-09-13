import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_nav_bar_state.freezed.dart';

@freezed
abstract class MutationNavBarState extends BaseBlocState
    with _$MutationNavBarState {
  const factory MutationNavBarState() = _MutationNavBarState;
  const MutationNavBarState._();
}
