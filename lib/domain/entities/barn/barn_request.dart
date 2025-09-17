import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'barn_request.freezed.dart';
part 'barn_request.g.dart';

@freezed
abstract class BarnRequest extends BaseInput with _$BarnRequest {
  const factory BarnRequest({
    @JsonKey(name: 'id_project') @Default('') String projectId,
    @JsonKey(name: 'search') @Default('') String search,
    @JsonKey(name: 'category') @Default('Drafting') String category,
  }) = _BarnRequest;
  const BarnRequest._();

  factory BarnRequest.fromJson(Map<String, dynamic> json) =>
      _$BarnRequestFromJson(json);
}
