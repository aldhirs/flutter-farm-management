import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/treatment/treatment_form_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_bulk_form_request.freezed.dart';
part 'treatment_bulk_form_request.g.dart';

@freezed
abstract class TreatmentBulkFormRequest extends BaseInput
    with _$TreatmentBulkFormRequest {
  const factory TreatmentBulkFormRequest({
    @JsonKey(name: 'id') @Default(null) int? id,
    @JsonKey(name: 'client_slug') @Default('') String client_slug,
    @JsonKey(name: 'id_project') @Default('') String id_project,
    @JsonKey(name: 'id_cattle') @Default('') String id_cattle,
    @JsonKey(name: 'id_treatment_type')
    @Default([])
    List<int> id_treatment_type,
    @JsonKey(name: 'treatment_date') @Default('') String treatment_date,
    @JsonKey(name: 'administered_by') @Default(0) int administered_by,
    @JsonKey(name: 'notes') @Default('') String notes,
  }) = _TreatmentBulkFormRequest;

  const TreatmentBulkFormRequest._();

  factory TreatmentBulkFormRequest.fromJson(Map<String, dynamic> json) =>
      _$TreatmentBulkFormRequestFromJson(json);
}
