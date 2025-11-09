import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/treatment/treatment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_treatment_state.freezed.dart';

@freezed
abstract class CattleTreatmentState extends BaseBlocState
    with _$CattleTreatmentState {
  const factory CattleTreatmentState({
    @Default([]) List<Treatment> items,
    @Default(Cattle()) Cattle cattle,
    @Default('') String errorMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
  }) = _CattleTreatmentState;
  const CattleTreatmentState._();
}
