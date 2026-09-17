import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

/// Satu kartu aksi di beranda.
///
/// Bentuknya baris, bukan ubin: ikon di kiri, label di kanan. Ubin memaksa
/// label dipotong atau dikecilkan, sedangkan baris memberi label seluruh lebar
/// yang tersisa — dan nama pekerjaan di aplikasi ini ("Pen Drafting",
/// "Tambah Sapi") memang tidak muat dalam satu kata.
class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  /// Menandai satu-satunya pekerjaan utama di layar ini.
  final bool primary;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.current;

    final Color surface = primary ? colors.mint700 : Colors.white;
    final Color foreground = primary ? Colors.white : colors.mint800;
    final Color iconWell = primary
        ? Colors.white.withValues(alpha: 0.16)
        : colors.mint200;
    final Color iconColor = primary ? Colors.white : colors.mint700;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(Dimens.d18),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.d18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.d18),
            border: primary ? null : Border.all(color: colors.neutral300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: iconWell,
                  borderRadius: BorderRadius.circular(Dimens.d12),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyles.body3().copyWith(
                    color: foreground,
                    fontWeight: primary ? FontWeight.w600 : FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
