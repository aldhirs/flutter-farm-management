import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drafting_list_state.freezed.dart';

@freezed
abstract class DraftingListState extends BaseBlocState
    with _$DraftingListState {
  const factory DraftingListState({
    @Default([]) List<Cattle> items,
    @Default('') String errorMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,

    /// Jumlah seluruh ternak yang menunggu didrafting di feedlot ini.
    ///
    /// Diambil dari `total` milik server, bukan dari panjang daftar yang
    /// sedang dimuat — daftarnya bertahap, dan menghitung panjangnya akan
    /// menampilkan angka yang naik sendiri setiap kali orang menggulir.
    @Default(0) int total,

    /// Halaman terakhir yang BERHASIL dimuat.
    ///
    /// Dicatat dari jawaban server, bukan dihitung dari panjang daftar.
    /// Menghitungnya dari panjang daftar tampak benar selama setiap halaman
    /// terisi penuh, lalu meleset begitu ada satu halaman yang pendek — dan
    /// halaman terakhir hampir selalu pendek. Setelah itu nomor halaman
    /// berikutnya mengulang halaman yang sama, sehingga baris yang sudah ada
    /// dimuat dua kali dan sisanya tidak pernah terambil.
    @Default(0) int page,
  }) = _DraftingListState;
  const DraftingListState._();
}
