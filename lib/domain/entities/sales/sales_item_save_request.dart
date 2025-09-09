import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_save_request.freezed.dart';
part 'sales_item_save_request.g.dart';

@freezed
abstract class SalesItemSaveRequest extends BaseInput
    with _$SalesItemSaveRequest {
  const factory SalesItemSaveRequest({
    @Default('') String id_sale,
    @Default([]) List<String> id_cattles,
  }) = _SalesItemSaveRequest;

  const SalesItemSaveRequest._();

  factory SalesItemSaveRequest.fromJson(Map<String, dynamic> json) =>
      _$SalesItemSaveRequestFromJson(json);
}
