import 'package:farm/base/base.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_state.freezed.dart';

@freezed
abstract class SalesState extends BaseBlocState with _$SalesState {
  const factory SalesState({
    @Default('') String filterStatus,

    /// Filter yang BENAR-BENAR menghasilkan daftar yang sedang terlihat.
    ///
    /// Dipisahkan dari [filterStatus], yang berubah begitu pengguna menyentuh
    /// dropdown — sebelum ia menekan Terapkan, dan bahkan bila ia menutup
    /// lembarannya tanpa menerapkan apa pun. Menandai tombol dari nilai itu
    /// akan menyalakannya di atas daftar yang sama sekali belum disaring.
    @Default('') String appliedFilterStatus,
    @Default([]) List<Sales> sales,
    @Default('') String errorMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
  }) = _SalesState;
  const SalesState._();

  /// Filter sedang benar-benar menyaring sesuatu.
  ///
  /// Diukur dari nilai yang dikirim ke server, bukan dari "sudah pernah
  /// dipilih". `filterStatus` menyimpan LABEL, dan salah satu labelnya adalah
  /// 'Semua' yang dipetakan ke kunci kosong — memilihnya berarti mematikan
  /// filter. Menganggapnya aktif hanya karena tidak kosong akan membuat tombol
  /// menyala terus setelah pengguna justru menghapus filternya.
  bool get isFilterActive => statusKeyOf(appliedFilterStatus).isNotEmpty;

  /// Kunci status untuk dikirim ke API, kosong berarti tanpa filter.
  ///
  /// 'Semua' adalah salah satu label yang bisa dipilih dan dipetakan ke kunci
  /// kosong, jadi "ada isinya" bukan ukuran yang benar untuk menyebut sebuah
  /// filter aktif.
  static String statusKeyOf(String label) {
    if (label.isEmpty) {
      return '';
    }
    for (final entry in salesStatusMap.entries) {
      if (entry.value == label) {
        return entry.key;
      }
    }
    return '';
  }
}
