import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_request.freezed.dart';
part 'mutation_request.g.dart';

@freezed
abstract class MutationRequest extends BaseInput with _$MutationRequest {
  const factory MutationRequest({
    @Default('') String from_project_id,
    @Default('') String to_project_id,
    @Default(1) int page,
    @Default(30) int limit,
    @Default('') String status,
  }) = _MutationRequest;

  const MutationRequest._();

  factory MutationRequest.fromJson(Map<String, dynamic> json) =>
      _$MutationRequestFromJson(json);
}
