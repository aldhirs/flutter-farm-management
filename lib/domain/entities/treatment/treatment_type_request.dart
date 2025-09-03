import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_type_request.freezed.dart';
part 'treatment_type_request.g.dart';

@freezed
abstract class TreatmentTypeRequest extends BaseInput
    with _$TreatmentTypeRequest {
  const factory TreatmentTypeRequest({
    @JsonKey(name: 'client_slug') @Default('') String clientSlug,
    @JsonKey(name: 'page') @Default(1) int page,
    @JsonKey(name: 'limit') @Default(200) int limit,
  }) = _TreatmentTypeRequest;

  const TreatmentTypeRequest._();

  factory TreatmentTypeRequest.fromJson(Map<String, dynamic> json) =>
      _$TreatmentTypeRequestFromJson(json);
}
