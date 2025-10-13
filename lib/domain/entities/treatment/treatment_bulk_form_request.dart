import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/treatment/treatment_form_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_bulk_form_request.freezed.dart';
part 'treatment_bulk_form_request.g.dart';

@freezed
abstract class TreatmentBulkFormRequest extends BaseInput
    with _$TreatmentBulkFormRequest {
  const factory TreatmentBulkFormRequest({
    @Default([]) List<TreatmentFormRequest> treatments,
  }) = _TreatmentBulkFormRequest;

  const TreatmentBulkFormRequest._();

  factory TreatmentBulkFormRequest.fromJson(Map<String, dynamic> json) =>
      _$TreatmentBulkFormRequestFromJson(json);
}
