import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed_request.freezed.dart';
part 'breed_request.g.dart';

@freezed
abstract class BreedRequest extends BaseInput with _$BreedRequest {
  const factory BreedRequest({
    @Default('') String client_slug,
    @Default('') String id_reception,
    @Default(1) int page,
    @Default(50) int limit,
  }) = _BreedRequest;
  const BreedRequest._();

  factory BreedRequest.fromJson(Map<String, dynamic> json) =>
      _$BreedRequestFromJson(json);
}
