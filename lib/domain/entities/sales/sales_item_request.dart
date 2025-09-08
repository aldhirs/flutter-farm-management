import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_request.freezed.dart';
part 'sales_item_request.g.dart';

@freezed
abstract class SalesItemRequest extends BaseInput with _$SalesItemRequest {
  const factory SalesItemRequest({
    @Default('') String id_sale,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _SalesItemRequest;

  const SalesItemRequest._();

  factory SalesItemRequest.fromJson(Map<String, dynamic> json) =>
      _$SalesItemRequestFromJson(json);
}
