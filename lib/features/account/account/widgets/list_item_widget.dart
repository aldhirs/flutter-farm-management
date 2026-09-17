import 'package:farm/features/account/account/model/account_menu_item.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

/// Satu baris menu di halaman akun.
///
/// Sebelumnya barisnya hanya ikon kecil dan sebaris nama, tanpa penanda bahwa
/// ia bisa ditekan dan tanpa keterangan apa pun tentang apa yang akan terjadi.
/// "Keluar" dan "Ubah Kata Sandi" karenanya terlihat persis sama — dua baris
/// abu bersebelahan, satu di antaranya mengakhiri sesi.
class ListItemWidget extends StatelessWidget {
  const ListItemWidget({super.key, required this.menuItem});

  final AccountMenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.current;

    /// Tindakan yang mengakhiri sesi memakai warna peringatan, yang lain ungu.
    final Color accent = menuItem.isDestructive
        ? colors.crimson500
        : colors.mint700;
    final Color badgeFill = menuItem.isDestructive
        ? colors.crimson200
        : colors.mint200;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onTap,
        splashColor: accent.withValues(alpha: 0.12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.d16,
            vertical: Dimens.d14,
          ),
          child: Row(
            children: [
              Container(
                width: Dimens.d40,
                height: Dimens.d40,
                decoration: BoxDecoration(
                  color: badgeFill,
                  borderRadius: BorderRadius.circular(Dimens.d12),
                ),
                alignment: Alignment.center,
                child: IconTheme(
                  data: IconThemeData(size: Dimens.d20, color: accent),
                  child: menuItem.icon ?? const SizedBox.shrink(),
                ),
              ),
              const SizedBox(width: Dimens.d14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menuItem.name,
                      style: TextStyles.body2().copyWith(
                        fontWeight: FontWeight.w600,
                        color: menuItem.isDestructive
                            ? colors.crimson500
                            : colors.mint800,
                      ),
                    ),
                    if (menuItem.description.isNotEmpty) ...[
                      const SizedBox(height: Dimens.d2),
                      Text(
                        menuItem.description,
                        style: TextStyles.label3().copyWith(
                          color: colors.neutral600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Dimens.d8),
              Icon(
                Icons.chevron_right,
                size: Dimens.d20,
                color: menuItem.isDestructive ? accent : colors.neutral600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    if (menuItem.url.isNotEmpty) {
      // IntentUtils.openBrowserURL(url: menuItem.url);
      return;
    }
    menuItem.action?.call();
  }
}
