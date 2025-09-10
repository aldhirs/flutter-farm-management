import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_move_request.freezed.dart';
part 'sales_item_move_request.g.dart';

@freezed
abstract class SalesItemMoveRequest extends BaseInput
    with _$SalesItemMoveRequest {
  const factory SalesItemMoveRequest({
    @Default('') String sale_id,
    @Default('') String to_sale_id,
    @Default([]) List<String> sale_item_ids,
  }) = _SalesItemMoveRequest;

  const SalesItemMoveRequest._();

  factory SalesItemMoveRequest.fromJson(Map<String, dynamic> json) =>
      _$SalesItemMoveRequestFromJson(json);
}
