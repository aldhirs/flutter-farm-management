import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'level_request.freezed.dart';
part 'level_request.g.dart';

@freezed
abstract class LevelRequest extends BaseInput with _$LevelRequest {
  const factory LevelRequest({
    @JsonKey(name: 'client_slug') @Default('') String clientSlug,
    @JsonKey(name: 'page') @Default(1) int page,
    @JsonKey(name: 'limit') @Default(100) int limit,
  }) = _LevelRequest;
  const LevelRequest._();

  factory LevelRequest.fromJson(Map<String, dynamic> json) =>
      _$LevelRequestFromJson(json);
}
