import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed.freezed.dart';
part 'breed.g.dart';

@freezed
abstract class Breed extends BaseInput with _$Breed {
  const factory Breed({
    @Default(0) int id,
    @Default('') String id_reception,
    @Default('') String name,
    @Default(0) int total_weight,
    @Default('') String created_at,
    @Default('') String updated_at,
    @Default(0) double created_by,
    @Default(Reception()) Reception reception,
  }) = _Breed;
  const Breed._();

  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);
}
