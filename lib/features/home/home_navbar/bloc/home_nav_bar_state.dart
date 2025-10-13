import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_nav_bar_state.freezed.dart';

@freezed
abstract class HomeNavBarState extends BaseBlocState with _$HomeNavBarState {
  const factory HomeNavBarState({
    @Default('') String earTag,
    @Default(false) bool loading,
    @Default('') String errorMessage,
    @Default(null) Cattle? cattle,
    @Default(0) int cattleDestination,
  }) = _HomeNavBarState;
  const HomeNavBarState._();
}
