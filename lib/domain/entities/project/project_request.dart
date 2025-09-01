import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_request.freezed.dart';
part 'project_request.g.dart';

@freezed
abstract class ProjectRequest extends BaseInput with _$ProjectRequest {
  const factory ProjectRequest({
    @JsonKey(name: 'client_slug') @Default('') String clientSlug,
  }) = _ProjectRequest;
  const ProjectRequest._();

  factory ProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$ProjectRequestFromJson(json);
}
