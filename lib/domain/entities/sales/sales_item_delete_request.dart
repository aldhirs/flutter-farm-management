import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_delete_request.freezed.dart';
part 'sales_item_delete_request.g.dart';

@freezed
abstract class SalesItemDeleteRequest extends BaseInput
    with _$SalesItemDeleteRequest {
  const factory SalesItemDeleteRequest({
    @Default('') String sale_id,
    @Default([]) List<SalesItem> items,
  }) = _SalesItemDeleteRequest;

  const SalesItemDeleteRequest._();

  factory SalesItemDeleteRequest.fromJson(Map<String, dynamic> json) =>
      _$SalesItemDeleteRequestFromJson(json);
}
