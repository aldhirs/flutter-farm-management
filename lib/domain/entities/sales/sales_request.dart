import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_request.freezed.dart';
part 'sales_request.g.dart';

@freezed
abstract class SalesRequest extends BaseInput with _$SalesRequest {
  const factory SalesRequest({
    @JsonKey(name: 'id_project') @Default('') String id_project,
    @JsonKey(name: 'page') @Default(1) int page,
    @JsonKey(name: 'limit') @Default(30) int limit,
    @JsonKey(name: 'status') @Default('') String status,
  }) = _SalesRequest;

  const SalesRequest._();

  factory SalesRequest.fromJson(Map<String, dynamic> json) =>
      _$SalesRequestFromJson(json);
}
