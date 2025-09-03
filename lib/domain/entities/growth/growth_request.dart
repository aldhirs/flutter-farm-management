import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth_request.freezed.dart';
part 'growth_request.g.dart';

@freezed
abstract class GrowthRequest extends BaseInput with _$GrowthRequest {
  const factory GrowthRequest({@JsonKey(name: 'id') @Default('') String id}) =
      _GrowthRequest;
  const GrowthRequest._();

  factory GrowthRequest.fromJson(Map<String, dynamic> json) =>
      _$GrowthRequestFromJson(json);
}
