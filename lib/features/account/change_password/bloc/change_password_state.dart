import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

/// Panjang minimum kata sandi baru.
///
/// Angka yang sama dijaga server (`validate:"min=8"`). Diulang di sini bukan
/// karena pemeriksaan di layar menggantikan pemeriksaan di server — ia tidak —
/// melainkan supaya orang tahu syaratnya sebelum menekan tombol, bukan sesudah
/// menunggu jaringan hanya untuk ditolak.
const int kMinPasswordLength = 8;

@freezed
abstract class ChangePasswordState extends BaseBlocState
    with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default('') String oldPassword,
    @Default('') String newPassword,
    @Default('') String confirmPassword,

    /// Menjadi true setelah tombol simpan ditekan sekali.
    ///
    /// Sebelum itu tidak ada satu pun kolom yang ditandai merah: menyalakan
    /// galat pada kolom yang belum sempat diisi memarahi orang karena belum
    /// selesai mengetik.
    @Default(false) bool submitted,
    @Default(false) bool loading,
    @Default('') String errorMessage,
  }) = _ChangePasswordState;
  const ChangePasswordState._();

  bool get oldValid => oldPassword.isNotEmpty;

  bool get newValid => newPassword.length >= kMinPasswordLength;

  bool get confirmValid =>
      confirmPassword.isNotEmpty && confirmPassword == newPassword;

  /// Kata sandi baru yang sama persis dengan yang lama bukan penggantian.
  ///
  /// Server menerimanya tanpa keluhan, jadi tanpa pemeriksaan ini orang bisa
  /// menekan simpan, melihat pesan berhasil, dan mengira kata sandinya sudah
  /// berganti padahal tidak ada yang berubah.
  bool get newIsSameAsOld =>
      newPassword.isNotEmpty && newPassword == oldPassword;

  bool get canSubmit =>
      oldValid && newValid && confirmValid && !newIsSameAsOld && !loading;
}
