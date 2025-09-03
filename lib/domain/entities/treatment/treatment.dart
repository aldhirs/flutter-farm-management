import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/treatment/treatment_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment.freezed.dart';
part 'treatment.g.dart';

@freezed
abstract class Treatment extends BaseOutput with _$Treatment {
  const factory Treatment({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'id_cattle') @Default('') String id_cattle,
    @JsonKey(name: 'treatment_type') TreatmentType? treatment_type,
    @JsonKey(name: 'treatment_date') @Default('') String treatment_date,
    @JsonKey(name: 'dosage') @Default('') String dosage,
    @JsonKey(name: 'unit') @Default('') String unit,
    @JsonKey(name: 'administered_by') UserData? administered_by,
    @JsonKey(name: 'notes') @Default('') String notes,
    @JsonKey(name: 'created_by') @Default(0) int created_by,
    @JsonKey(name: 'created_at') @Default('') String created_at,
    @JsonKey(name: 'updated_at') @Default('') String updated_at,
  }) = _Treatment;

  const Treatment._();

  factory Treatment.fromJson(Map<String, dynamic> json) =>
      _$TreatmentFromJson(json);
}
