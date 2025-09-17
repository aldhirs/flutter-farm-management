import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_id_request.freezed.dart';
part 'sale_id_request.g.dart';

@freezed
abstract class SaleIdRequest extends BaseInput with _$SaleIdRequest {
  const factory SaleIdRequest({@Default('') String id}) = _SaleIdRequest;

  const SaleIdRequest._();

  factory SaleIdRequest.fromJson(Map<String, dynamic> json) =>
      _$SaleIdRequestFromJson(json);
}
