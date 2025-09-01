import 'package:farm/domain/base/base.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pen.freezed.dart';
part 'pen.g.dart';

@freezed
abstract class Pen extends BaseOutput with _$Pen {
  const factory Pen({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'id_barn') @Default('') String id_barn,
    @JsonKey(name: 'name_barn') @Default('') String name_barn,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'capacity') @Default(0) int capacity,
    @JsonKey(name: 'cattle_count') @Default(0) int cattle_count,
    @JsonKey(name: 'created_at') @Default('') String created_at,
  }) = _Pen;
  const Pen._();
  factory Pen.fromJson(Map<String, dynamic> json) => _$PenFromJson(json);

  Color cattleToCapacityColor() {
    var percent = cattle_count / capacity;
    percent = percent.clamp(0.0, 1.0);

    if (percent <= 0.5) {
      // 0 → 50% : green → yellow
      return Color.lerp(Colors.green, Colors.yellow, percent / 0.5)!;
    } else if (percent <= 0.97) {
      // 50 → 97% : yellow → orange
      return Color.lerp(
        Colors.yellow,
        Colors.orange,
        (percent - 0.5) / (0.97 - 0.5),
      )!;
    } else {
      // 97 → 100% : solid red
      return Colors.red;
    }
  }
}
