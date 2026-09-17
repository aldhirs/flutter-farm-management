import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

/// Tombol filter mengambang yang memperlihatkan apakah filter sedang menyala.
///
/// Sebelumnya tombol ini terlihat sama persis baik saat daftar ditampilkan utuh
/// maupun saat sedang disaring. Akibatnya bukan sekadar kurang rapi: daftar yang
/// tersaring dan daftar yang memang kosong terlihat identik, dan orang
/// menyimpulkan datanya hilang padahal hanya sedang disembunyikan oleh filter
/// yang ia set beberapa layar sebelumnya.
///
/// Dua penanda dipakai bersamaan, bukan salah satu. Warna terlihat lebih dulu
/// dari seberang ruangan, tetapi warna saja tidak memberi tahu SEDANG disaring
/// apa — dan tidak terbaca sama sekali oleh mata yang sulit membedakan warna.
/// Karena itu labelnya sekalian menyebutkan nilainya.
///
/// Dipakai bersama oleh daftar penjualan dan mutasi lewat satu widget, bukan
/// disalin ke tiap halaman: aturan "kapan dianggap aktif" yang disalin ke
/// beberapa tempat akan berbeda di salah satunya, dan yang berbeda itulah yang
/// akan ditemukan orang.
class FilterFab extends StatelessWidget {
  const FilterFab({
    super.key,
    required this.isActive,
    required this.onPressed,
    this.activeLabel = '',
    this.heroTag,
  });

  /// Filter sedang menyaring sesuatu, yakni nilainya di luar nilai default.
  final bool isActive;

  /// Nilai yang sedang berlaku, ditampilkan di label saat [isActive].
  final String activeLabel;

  final VoidCallback onPressed;

  /// Wajib diisi bila dua tombol ini bisa hidup bersamaan di satu navigator —
  /// daftar mutasi menampilkan satu untuk tab masuk dan satu untuk tab keluar,
  /// dan tanpa tag yang berbeda Hero akan menolak keduanya.
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.current;

    /// Amber di atas cokelat tua: kontras 11.8:1, dan hangat sehingga tidak
    /// tertukar dengan ungu brand yang dipakai tombol aksi lain di layar yang
    /// sama.
    final background = isActive ? colors.gamboge400 : colors.mint700;
    final foreground = isActive ? colors.gamboge800 : Colors.white;

    final label = isActive && activeLabel.isNotEmpty
        ? 'Filter: $activeLabel'
        : 'Filter';

    return FloatingActionButton.extended(
      heroTag: heroTag,
      backgroundColor: background,
      onPressed: onPressed,
      label: Text(
        label,
        style: TextStyles.button2().copyWith(color: foreground),
      ),

      /// Ikon ikut berubah menjadi versi padat, supaya keadaan aktif masih
      /// terbaca pada tangkapan layar hitam putih dan oleh mata yang sulit
      /// membedakan warna.
      icon: Icon(
        isActive ? Icons.filter_alt : Icons.filter_list_alt,
        color: foreground,
      ),
    );
  }
}
