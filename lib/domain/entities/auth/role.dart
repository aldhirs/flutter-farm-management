import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';
part 'role.g.dart';

@freezed
abstract class Role extends BaseOutput with _$Role {
  const factory Role({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'description') @Default('') String description,
    @JsonKey(name: 'permission') dynamic permission,
  }) = _Role;

  const Role._();

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
