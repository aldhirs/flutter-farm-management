import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_form_request.freezed.dart';
part 'medical_form_request.g.dart';

@freezed
abstract class MedicalFormRequest extends BaseInput with _$MedicalFormRequest {
  const factory MedicalFormRequest({
    @JsonKey(name: 'id_project') @Default('') String id_project,
    @JsonKey(name: 'id_cattle') @Default('') String id_cattle,
    @JsonKey(name: 'id_medical_type') @Default(0) int id_medical_type,
    @JsonKey(name: 'is_infection') @Default(false) bool is_infection,
    @JsonKey(name: 'notes') @Default('') String notes,
    @JsonKey(name: 'status') @Default('') String status,
    @JsonKey(name: 'administered_by') @Default(0) int administered_by,
  }) = _MedicalFormRequest;

  const MedicalFormRequest._();

  factory MedicalFormRequest.fromJson(Map<String, dynamic> json) =>
      _$MedicalFormRequestFromJson(json);
}
