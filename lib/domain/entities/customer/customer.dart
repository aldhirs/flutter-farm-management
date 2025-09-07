import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
abstract class Customer extends BaseOutput with _$Customer {
  const factory Customer({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'client_slug') @Default('') String client_slug,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'type') @Default('') String type,
    @JsonKey(name: 'phone') @Default('') String phone,
    @JsonKey(name: 'email') @Default('') String email,
    @JsonKey(name: 'address') @Default('') String address,
    @JsonKey(name: 'npwp') @Default('') String npwp,
    @JsonKey(name: 'created_at') @Default('') String created_at,
    @JsonKey(name: 'updated_at') @Default('') String updated_at,
  }) = _Customer;

  const Customer._();

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
