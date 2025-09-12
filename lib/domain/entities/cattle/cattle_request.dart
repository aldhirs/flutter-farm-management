import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_request.freezed.dart';
part 'cattle_request.g.dart';

@freezed
abstract class CattleRequest extends BaseInput with _$CattleRequest {
  const factory CattleRequest({
    @JsonKey(name: 'rfid') @Default('') String rfid,
    @JsonKey(name: 'eartag') @Default('') String eartag,
    @JsonKey(name: 'id_project') @Default('') String id_project,
  }) = _CattleRequest;
  const CattleRequest._();

  factory CattleRequest.fromJson(Map<String, dynamic> json) =>
      _$CattleRequestFromJson(json);
}
