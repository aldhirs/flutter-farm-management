import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/medical/medical_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical.freezed.dart';
part 'medical.g.dart';

@freezed
abstract class Medical extends BaseOutput with _$Medical {
  const factory Medical({
    @Default(0) int id,
    @Default('') String id_cattle,
    MedicalType? medical_type,
    @Default(false) bool is_infection,
    @Default('') String dosage,
    @Default('') String unit,
    int? administered_by,
    @Default('') String notes,
    @Default(0) int created_by,
    @Default('') String created_at,
    @Default('') String updated_at,
  }) = _Medical;

  const Medical._();

  factory Medical.fromJson(Map<String, dynamic> json) =>
      _$MedicalFromJson(json);
}
