import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_type.freezed.dart';
part 'medical_type.g.dart';

@freezed
abstract class MedicalType extends BaseOutput with _$MedicalType {
  const factory MedicalType({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'description') @Default('') String description,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'updated_at') @Default('') String updatedAt,
  }) = _MedicalType;

  const MedicalType._();

  factory MedicalType.fromJson(Map<String, dynamic> json) =>
      _$MedicalTypeFromJson(json);
}
