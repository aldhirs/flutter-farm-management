import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_menu_item.freezed.dart';

@freezed
abstract class AccountMenuItem with _$AccountMenuItem {
  const factory AccountMenuItem({
    @Default('') String name,
    @Default('') String description,
    @Default(null) Widget? icon,
    @Default('') String url,
    @Default(0) int section,

    /// Tindakan yang tidak bisa ditarik kembali, seperti keluar dari aplikasi.
    ///
    /// Ditandai agar layar bisa memberinya warna dan tempat yang berbeda.
    /// Sebelumnya "Keluar" berdiri satu baris di bawah "Ubah Kata Sandi"
    /// dengan bentuk yang sama persis, sehingga ibu jari yang meleset satu
    /// baris mengeluarkan orang dari aplikasi alih-alih membuka formulir.
    @Default(false) bool isDestructive,
    VoidCallback? action,
  }) = _AccountMenuItem;
}
