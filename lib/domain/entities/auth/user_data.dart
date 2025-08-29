import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
abstract class UserData extends BaseOutput with _$UserData {
  const factory UserData({
    @JsonKey(name: 'id') @Default(0) double id,
    @JsonKey(name: 'client_slug') @Default('') String clientSlug,
    @JsonKey(name: 'role_id') @Default(0) double roleId,
    @JsonKey(name: 'username') @Default('') String username,
    @JsonKey(name: 'email') @Default('') String email,
    @JsonKey(name: 'token') @Default('') String token,
  }) = _UserData;
  const UserData._();
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
