import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_add_request.freezed.dart';
part 'sales_item_add_request.g.dart';

@freezed
abstract class SalesItemAddRequest extends BaseInput
    with _$SalesItemAddRequest {
  const factory SalesItemAddRequest({
    @Default('') String id_sale,
    @Default('') String id_cattle,
    @Default('') String id_pen,
    @Default(0) int weight,
  }) = _SalesItemAddRequest;

  const SalesItemAddRequest._();

  factory SalesItemAddRequest.fromJson(Map<String, dynamic> json) =>
      _$SalesItemAddRequestFromJson(json);
}
