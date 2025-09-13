import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@freezed
abstract class Supplier extends BaseInput with _$Supplier {
  const factory Supplier({
    @Default('') String id,
    @Default('') String client_slug,
    @Default('') String company_name,
    @Default('') String type,
    @Default('') String email,
    @Default('') String phone,
  }) = _Supplier;
  const Supplier._();

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}
