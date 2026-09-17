import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_request.freezed.dart';
part 'change_password_request.g.dart';

/// Hanya dua kolom yang dikirim.
///
/// Konfirmasi kata sandi tidak ikut: ia dicocokkan di layar dan tidak pernah
/// sampai ke server, karena server tidak punya urusan dengan seseorang yang
/// salah mengetik dua kali. Akun yang diubah juga tidak disebut di sini —
/// server mengambilnya dari token, sehingga permintaan ini tidak bisa dipakai
/// untuk mengganti kata sandi orang lain.
@freezed
abstract class ChangePasswordRequest extends BaseInput
    with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    @JsonKey(name: 'old_password') @Default('') String oldPassword,
    @JsonKey(name: 'new_password') @Default('') String newPassword,
  }) = _ChangePasswordRequest;
  const ChangePasswordRequest._();

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}
