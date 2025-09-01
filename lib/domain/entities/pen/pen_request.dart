import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pen_request.freezed.dart';
part 'pen_request.g.dart';

@freezed
abstract class PenRequest extends BaseInput with _$PenRequest {
  const factory PenRequest({
    @JsonKey(name: 'id_barn') @Default('') String barnId,
    @JsonKey(name: 'id_project') @Default('') String projectId,
    @JsonKey(name: 'barn_category') @Default('Drafting') String barnCategory,
    @JsonKey(name: 'page') @Default(1) int page,
    @JsonKey(name: 'limit') @Default(100) int limit,
  }) = _PenRequest;
  const PenRequest._();

  factory PenRequest.fromJson(Map<String, dynamic> json) =>
      _$PenRequestFromJson(json);
}
