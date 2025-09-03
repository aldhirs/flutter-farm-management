import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_form_request.freezed.dart';
part 'treatment_form_request.g.dart';

@freezed
abstract class TreatmentFormRequest extends BaseInput
    with _$TreatmentFormRequest {
  const factory TreatmentFormRequest({
    @JsonKey(name: 'id') @Default(null) int? id,
    @JsonKey(name: 'client_slug') @Default('') String client_slug,
    @JsonKey(name: 'id_project') @Default('') String id_project,
    @JsonKey(name: 'id_cattle') @Default('') String id_cattle,
    @JsonKey(name: 'id_treatment_type') @Default(0) int id_treatment_type,
    @JsonKey(name: 'treatment_date') @Default('') String treatment_date,
    @JsonKey(name: 'administered_by') @Default(0) int administered_by,
    @JsonKey(name: 'notes') @Default('') String notes,
  }) = _TreatmentFormRequest;

  const TreatmentFormRequest._();

  factory TreatmentFormRequest.fromJson(Map<String, dynamic> json) =>
      _$TreatmentFormRequestFromJson(json);
}
