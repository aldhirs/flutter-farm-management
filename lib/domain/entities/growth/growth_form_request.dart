import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth_form_request.freezed.dart';
part 'growth_form_request.g.dart';

@freezed
abstract class GrowthFormRequest extends BaseInput with _$GrowthFormRequest {
  const factory GrowthFormRequest({
    @JsonKey(name: 'id') @Default(null) int? id,
    @JsonKey(name: 'cattle_id') @Default('') String cattle_id,
    @JsonKey(name: 'date_activity') @Default('') String date_activity,
    @JsonKey(name: 'weight') @Default(0) int weight,
  }) = _GrowthFormRequest;
  const GrowthFormRequest._();

  factory GrowthFormRequest.fromJson(Map<String, dynamic> json) =>
      _$GrowthFormRequestFromJson(json);
}
