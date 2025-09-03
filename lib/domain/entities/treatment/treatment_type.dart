import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_type.freezed.dart';
part 'treatment_type.g.dart';

@freezed
abstract class TreatmentType extends BaseOutput with _$TreatmentType {
  const factory TreatmentType({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'code') @Default('') String code,
    @JsonKey(name: 'category') @Default('') String category,
    @JsonKey(name: 'description') @Default('') String description,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'updated_at') @Default('') String updatedAt,
  }) = _TreatmentType;

  const TreatmentType._();

  factory TreatmentType.fromJson(Map<String, dynamic> json) =>
      _$TreatmentTypeFromJson(json);
}
