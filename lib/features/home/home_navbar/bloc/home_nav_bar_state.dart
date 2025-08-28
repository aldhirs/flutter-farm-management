import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_nav_bar_state.freezed.dart';

@freezed
abstract class HomeNavBarState extends BaseBlocState with _$HomeNavBarState {
  const factory HomeNavBarState() = _HomeNavBarState;
  const HomeNavBarState._();
}
