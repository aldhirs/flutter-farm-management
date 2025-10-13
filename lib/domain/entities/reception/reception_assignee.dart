import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reception_assignee.freezed.dart';
part 'reception_assignee.g.dart';

@freezed
abstract class ReceptionAssignee extends BaseOutput with _$ReceptionAssignee {
  const factory ReceptionAssignee({
    @Default(0) int id,
    @Default('') String id_reception,
    @Default('') String id_project,
    @Default(null) String? dof,
    @Default('') String id_barn,
    @Default('') String id_pen,
    @Default('') String created_at,
    @Default('') String updated_at,
    @Default(0) double created_by,
    @Default(Reception()) Reception reception,
  }) = _ReceptionAssignee;
  const ReceptionAssignee._();
  factory ReceptionAssignee.fromJson(Map<String, dynamic> json) =>
      _$ReceptionAssigneeFromJson(json);
}
