import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/customer/customer.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales.freezed.dart';
part 'sales.g.dart';

@freezed
abstract class Sales extends BaseOutput with _$Sales {
  const factory Sales({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'status') @Default('') String status,
    @JsonKey(name: 'issued_at') @Default('') String issued_at,
    @JsonKey(name: 'issued_by') @Default(0) int issued_by,
    @JsonKey(name: 'created_at') @Default('') String created_at,
    @JsonKey(name: 'updated_at') @Default('') String updated_at,
    @JsonKey(name: 'customer_detail')
    @Default(Customer())
    Customer? customer_detail,
  }) = _Sales;
  const Sales._();
  factory Sales.fromJson(Map<String, dynamic> json) => _$SalesFromJson(json);

  String statusLabel() {
    if (status.isEmpty) {
      return '-';
    }
    return salesStatusMap.entries
        .firstWhere((item) => item.key == status)
        .value;
  }

  bool isDraft() {
    return status == DRAFT;
  }

  TagCategoryType statusType() {
    switch (status) {
      case DRAFT:
        return TagCategoryType.gamboge;
      case ISSUED:
        return TagCategoryType.eucalyptus;
      case COMPLETED:
        return TagCategoryType.eucalyptus;
      case CANCELLED:
        return TagCategoryType.crismon;
    }
    return TagCategoryType.plain;
  }
}
