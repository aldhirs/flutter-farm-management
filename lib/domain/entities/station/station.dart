import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station.freezed.dart';
part 'station.g.dart';

@freezed
abstract class Station extends BaseInput with _$Station {
  const factory Station({
    @Default(0) int id,
    @Default('') String id_reception,
    @Default('') String name,
    @Default('') String created_at,
    @Default('') String updated_at,
    @Default(0) int created_by,
    @Default(Reception()) Reception reception,
  }) = _Station;
  const Station._();

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
}
