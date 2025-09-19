import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState extends BaseBlocState with _$HomeState {
  const factory HomeState({
    @Default('') String earTag,
    @Default(false) bool loading,
    @Default('') String errorMessage,
    @Default(null) Cattle? cattle,
  }) = _HomeState;
  const HomeState._();
}
