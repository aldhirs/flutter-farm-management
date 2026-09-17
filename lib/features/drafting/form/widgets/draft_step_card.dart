import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

/// Satu langkah drafting pada daftar di halaman formulir.
///
/// Keempat langkah memakai kartu yang sama persis. Sebelumnya masing-masing
/// menyusun kartunya sendiri dengan kode yang nyaris identik, dan setiap kali
/// salah satunya disentuh, tiga lainnya tertinggal — sehingga tinggi, tepi, dan
/// warna keempatnya perlahan menyimpang satu sama lain.
///
/// Keadaan "sudah diisi" ditandai tiga hal sekaligus — bidang, tepi, dan ikon —
/// karena kartu ini dibaca sambil berdiri di kandang, sering di bawah matahari,
/// tempat beda warna yang tipis saja tidak cukup terlihat.
class DraftStepCard extends StatelessWidget {
  const DraftStepCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.onTap,
  });

  final IconData icon;
  final String title;

  /// Apa yang sebenarnya diisi di langkah ini.
  ///
  /// Nama langkah saja — "Timbang", "Medis" — belum memberi tahu petugas baru
  /// apa yang akan diminta di balik kartunya.
  final String subtitle;
  final bool isDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.current;

    return Semantics(
      button: true,
      label: '$title, ${isDone ? 'sudah diisi' : 'belum diisi'}',
      child: Material(
        color: isDone ? colors.mint200 : Colors.white,
        borderRadius: BorderRadius.circular(Dimens.d18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimens.d18),
          splashColor: colors.mint300.withValues(alpha: 0.25),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.d18),
              border: Border.all(
                color: isDone ? colors.mint700 : colors.neutral300,
                width: isDone ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.d16),
              child: Row(
                children: [
                  _badge(colors),
                  const SizedBox(width: Dimens.d14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyles.body2().copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.mint800,
                          ),
                        ),
                        const SizedBox(height: Dimens.d2),
                        Text(
                          isDone ? 'Sudah diisi · ketuk untuk ubah' : subtitle,
                          style: TextStyles.label3().copyWith(
                            color: isDone ? colors.mint700 : colors.neutral600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimens.d8),
                  Icon(
                    isDone ? Icons.check_circle : Icons.chevron_right,
                    size: Dimens.d22,
                    color: isDone ? colors.mint700 : colors.neutral600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Lencana pembuka kartu; warnanya ikut menandai keadaan langkah.
  Widget _badge(AppColors colors) {
    return Container(
      width: Dimens.d44,
      height: Dimens.d44,
      decoration: BoxDecoration(
        color: isDone ? colors.mint700 : colors.mint200,
        borderRadius: BorderRadius.circular(Dimens.d14),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: Dimens.d20,
        color: isDone ? Colors.white : colors.mint700,
      ),
    );
  }
}
