import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed.freezed.dart';
part 'breed.g.dart';

@freezed
abstract class Breed extends BaseInput with _$Breed {
  const factory Breed({
    @Default('') String id,
    @Default('') String client_slug,
    @Default('') String name,
    @Default('') String category,
  }) = _Breed;
  const Breed._();

  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);
}
