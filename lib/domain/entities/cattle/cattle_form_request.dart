import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_form_request.freezed.dart';
part 'cattle_form_request.g.dart';

@freezed
abstract class CattleFormRequest extends BaseInput with _$CattleFormRequest {
  const factory CattleFormRequest({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'project_id') @Default('') String project_id,
    @JsonKey(name: 'rfid') @Default('') String rfid,
    @JsonKey(name: 'barn_id') @Default('') String barn_id,
    @JsonKey(name: 'pen_id') @Default('') String pen_id,
    @JsonKey(name: 'supplier_id') @Default('') String supplier_id,
    @JsonKey(name: 'station_id') @Default('') String station_id,
    @JsonKey(name: 'breed_id') @Default('') String breed_id,
    @JsonKey(name: 'ear_tag') @Default('') String ear_tag,
    @JsonKey(name: 'reception_id') @Default('') String reception_id,
    @JsonKey(name: 'status') @Default('') String status,
  }) = _CattleFormRequest;
  const CattleFormRequest._();

  factory CattleFormRequest.fromJson(Map<String, dynamic> json) =>
      _$CattleFormRequestFromJson(json);
}
