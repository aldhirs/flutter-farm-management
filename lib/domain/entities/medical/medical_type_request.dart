import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_type_request.freezed.dart';
part 'medical_type_request.g.dart';

@freezed
abstract class MedicalTypeRequest extends BaseInput with _$MedicalTypeRequest {
  const factory MedicalTypeRequest({
    @JsonKey(name: 'client_slug') @Default('') String clientSlug,
    @JsonKey(name: 'page') @Default(1) int page,
    @JsonKey(name: 'limit') @Default(200) int limit,
  }) = _MedicalTypeRequest;

  const MedicalTypeRequest._();

  factory MedicalTypeRequest.fromJson(Map<String, dynamic> json) =>
      _$MedicalTypeRequestFromJson(json);
}
