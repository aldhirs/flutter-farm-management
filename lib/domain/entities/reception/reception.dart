import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reception.freezed.dart';
part 'reception.g.dart';

@freezed
abstract class Reception extends BaseOutput with _$Reception {
  const factory Reception({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'bl_number') @Default('') String bl_number,
    @JsonKey(name: 'received_date') @Default('') String received_date,
    @JsonKey(name: 'created_at') @Default('') String created_at,
    @JsonKey(name: 'updated_at') @Default('') String updated_at,
    @JsonKey(name: 'created_by') @Default(0) double created_by,
  }) = _Reception;
  const Reception._();
  factory Reception.fromJson(Map<String, dynamic> json) =>
      _$ReceptionFromJson(json);
}
