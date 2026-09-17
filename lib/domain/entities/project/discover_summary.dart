import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_summary.freezed.dart';
part 'discover_summary.g.dart';

/// Empat angka yang ditampilkan kartu Discover di beranda, untuk satu feedlot.
///
/// Selalu milik satu feedlot, tidak pernah gabungan: pertanyaan "berapa draf
/// sapi" baru punya arti setelah seseorang memilih feedlot mana yang sedang ia
/// kerjakan. Karena itu beranda tidak memanggil endpoint ini sebelum feedlot
/// dipilih, dan menampilkan tanda hubung alih-alih angka.
@freezed
abstract class DiscoverSummary extends BaseOutput with _$DiscoverSummary {
  const factory DiscoverSummary({
    /// Sapi yang belum didrafting: belum punya kandang dan belum punya pen.
    @JsonKey(name: 'draft_cattle') @Default(0) int draftCattle,

    /// Penjualan yang masih berstatus draft saja.
    @JsonKey(name: 'draft_sales') @Default(0) int draftSales,

    @JsonKey(name: 'mutation_in') @Default(0) int mutationIn,
    @JsonKey(name: 'mutation_out') @Default(0) int mutationOut,

    /// Waktu server menghitung angka-angka ini (RFC3339).
    ///
    /// Datang dari server, bukan dari jam perangkat. Beranda dulu mencetak
    /// `DateTime.now()` milik telepon, sehingga baris "Terakhir diperbarui"
    /// selalu terlihat baru — bahkan ketika angkanya gagal dimuat, dan bahkan
    /// ketika jam teleponnya sendiri salah.
    @JsonKey(name: 'last_updated') @Default('') String lastUpdated,
  }) = _DiscoverSummary;
  const DiscoverSummary._();

  factory DiscoverSummary.fromJson(Map<String, dynamic> json) =>
      _$DiscoverSummaryFromJson(json);
}
