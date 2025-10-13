import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reception.freezed.dart';
part 'reception.g.dart';

@freezed
abstract class Reception extends BaseOutput with _$Reception {
  const factory Reception({
    @Default('') String id,
    @Default('') String title,
    @Default('') String client_slug,
    @Default('') String file_name,
    @Default('') String received_date,
    @Default('') String created_at,
    @Default('') String updated_at,
    @Default(0) double created_by,
  }) = _Reception;
  const Reception._();
  factory Reception.fromJson(Map<String, dynamic> json) =>
      _$ReceptionFromJson(json);
}
