import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_request.freezed.dart';
part 'supplier_request.g.dart';

@freezed
abstract class SupplierRequest extends BaseInput with _$SupplierRequest {
  const factory SupplierRequest({
    @Default('') String client_slug,
    @Default('') String id_reception,
    @Default(1) int page,
    @Default(50) int limit,
  }) = _SupplierRequest;
  const SupplierRequest._();

  factory SupplierRequest.fromJson(Map<String, dynamic> json) =>
      _$SupplierRequestFromJson(json);
}
