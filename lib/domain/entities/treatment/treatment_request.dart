import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_request.freezed.dart';
part 'treatment_request.g.dart';

@freezed
abstract class TreatmentRequest extends BaseInput with _$TreatmentRequest {
  const factory TreatmentRequest({
    @Default('') String id_cattle,
    @Default('') String id_project,
    @Default('') String client_slug,
    @Default(1) int page,
    @Default(50) int limit,
  }) = _TreatmentRequest;

  const TreatmentRequest._();

  factory TreatmentRequest.fromJson(Map<String, dynamic> json) =>
      _$TreatmentRequestFromJson(json);
}
