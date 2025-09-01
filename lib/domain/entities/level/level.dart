import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'level.freezed.dart';
part 'level.g.dart';

@freezed
abstract class Level extends BaseOutput with _$Level {
  const factory Level({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'client_slug') @Default('') String client_slug,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'estimation_day') @Default(0) int estimation_day,
  }) = _Level;
  const Level._();
  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
}
