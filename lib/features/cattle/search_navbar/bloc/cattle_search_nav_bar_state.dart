import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_search_nav_bar_state.freezed.dart';

@freezed
abstract class CattleSearchNavBarState extends BaseBlocState
    with _$CattleSearchNavBarState {
  const factory CattleSearchNavBarState() = _CattleSearchNavBarState;
  const CattleSearchNavBarState._();
}
