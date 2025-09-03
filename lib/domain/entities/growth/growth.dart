import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth.freezed.dart';
part 'growth.g.dart';

@freezed
abstract class Growth extends BaseOutput with _$Growth {
  const factory Growth({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'date_activity') @Default('') String date_activity,
    @JsonKey(name: 'weight') @Default(0) int weight,
    @JsonKey(name: 'created_at') @Default('') String created_at,
  }) = _Growth;
  const Growth._();
  factory Growth.fromJson(Map<String, dynamic> json) => _$GrowthFromJson(json);
}
