import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_request.freezed.dart';
part 'cattle_request.g.dart';

@freezed
abstract class CattleRequest extends BaseInput with _$CattleRequest {
  const factory CattleRequest({
    @JsonKey(name: 'rfid') @Default('') String rfid,
  }) = _CattleRequest;
  const CattleRequest._();

  factory CattleRequest.fromJson(Map<String, dynamic> json) =>
      _$CattleRequestFromJson(json);
}
