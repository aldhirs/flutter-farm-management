import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item.freezed.dart';
part 'sales_item.g.dart';

@freezed
abstract class SalesItem extends BaseOutput with _$SalesItem {
  const factory SalesItem({
    @Default('') String id,
    @Default('') String id_sale,
    @Default('') String id_cattle,
    @Default('') String rfid,
    @Default('') String ear_tag,
    @Default(0) int actual_weight,
    @Default('') String cattle_status,
    @Default('') String status,
    @Default(0) int created_by,
  }) = _SalesItem;

  const SalesItem._();

  factory SalesItem.fromJson(Map<String, dynamic> json) =>
      _$SalesItemFromJson(json);

  String statusLabel() {
    if (status.isEmpty) return '-';
    return salesItemStatusMap[status] ?? status;
  }

  String cattleStatusLabel() {
    if (cattle_status.isEmpty) return '-';
    return cattleStatusMap[cattle_status] ?? cattle_status;
  }
}
