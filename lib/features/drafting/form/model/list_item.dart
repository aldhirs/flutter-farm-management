import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_item.freezed.dart';

@freezed
abstract class ListItem with _$ListItem {
  const factory ListItem({
    @Default('') String name,
    @Default('') String description,

    /// Nama bagian tempat baris ini dikelompokkan pada lembar keterangan.
    ///
    /// Kosong berarti tidak dikelompokkan — layar lama yang menampilkan baris
    /// ini sebagai satu daftar panjang tidak perlu ikut berubah.
    @Default('') String group,
    @Default(null) Widget? icon,
    VoidCallback? action,
  }) = _ListItem;
}
