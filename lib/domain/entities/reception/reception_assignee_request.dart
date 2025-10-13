import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reception_assignee_request.freezed.dart';
part 'reception_assignee_request.g.dart';

@freezed
abstract class ReceptionAssigneeRequest extends BaseInput
    with _$ReceptionAssigneeRequest {
  const factory ReceptionAssigneeRequest({
    @Default('') String search,
    @Default('') String client_slug,
    @Default('') String id_project,
  }) = _ReceptionAssigneeRequest;
  const ReceptionAssigneeRequest._();

  factory ReceptionAssigneeRequest.fromJson(Map<String, dynamic> json) =>
      _$ReceptionAssigneeRequestFromJson(json);
}
