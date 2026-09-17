import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Foto pengguna, atau inisial namanya bila tidak ada foto.
///
/// Belum ada satu pun foto di sistem ini — `avatarUrl` selalu kosong — jadi
/// yang sebelumnya terjadi adalah permintaan jaringan ke alamat kosong yang
/// pasti gagal, lalu gambar siluet abu yang sama untuk semua orang. Inisial
/// setidaknya menyebut siapa yang sedang masuk, dan tidak perlu jaringan.
class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.avatarUrl,
    this.name = '',
    this.size = Dimens.d56,
  });

  final String avatarUrl;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: SizedBox(
        width: size,
        height: size,
        child: avatarUrl.isEmpty ? _initials() : _remote(),
      ),
    );
  }

  Widget _remote() {
    return Image.network(
      avatarUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return avatarUrl.isSvg()
            ? SvgPicture.network(avatarUrl, width: size, height: size)
            : _initials();
      },
    );
  }

  Widget _initials() {
    return Container(
      color: Colors.white.withValues(alpha: 0.16),
      alignment: Alignment.center,
      child: Text(
        _monogram(),
        style: TextStyles.heading6().copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Dua huruf pertama dari dua kata pertama nama.
  ///
  /// Nama lengkap di sistem ini kerap berisi empat kata atau lebih; mengambil
  /// semuanya menghasilkan deret huruf yang tidak terbaca di lingkaran sekecil
  /// ini.
  String _monogram() {
    final words = name.trim().split(RegExp(r'\s+'))
      ..removeWhere((word) => word.isEmpty);
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.characters.first.toUpperCase();
    return (words[0].characters.first + words[1].characters.first)
        .toUpperCase();
  }
}
