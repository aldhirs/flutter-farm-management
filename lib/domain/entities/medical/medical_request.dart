import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_request.freezed.dart';
part 'medical_request.g.dart';

@freezed
abstract class MedicalRequest extends BaseInput with _$MedicalRequest {
  const factory MedicalRequest({
    @Default('') String id_cattle,
    @Default('') String id_project,
    @Default('') String client_slug,
    @Default(1) int page,
    @Default(50) int limit,
  }) = _MedicalRequest;

  const MedicalRequest._();

  factory MedicalRequest.fromJson(Map<String, dynamic> json) =>
      _$MedicalRequestFromJson(json);
}
