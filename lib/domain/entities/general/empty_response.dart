import 'package:freezed_annotation/freezed_annotation.dart';

part 'empty_response.freezed.dart';
part 'empty_response.g.dart';

@freezed
abstract class EmptyResponse with _$EmptyResponse {
  const factory EmptyResponse() = _EmptyResponse;

  factory EmptyResponse.fromJson(Map<String, dynamic> json) =>
      _$EmptyResponseFromJson(json);
}
