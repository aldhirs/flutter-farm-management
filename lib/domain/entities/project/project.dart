import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
abstract class Project extends BaseOutput with _$Project {
  const factory Project({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'name') @Default('') String name,
  }) = _Project;
  const Project._();
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
