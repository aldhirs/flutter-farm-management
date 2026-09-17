import 'package:farm/extensions/string.dart';
import 'package:farm/features/drafting/form/model/list_item.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

/// Keterangan lengkap sapi yang sedang didrafting.
///
/// Dulu ini sebuah akordeon di kepala halaman. Akordeon menyimpan isinya di
/// tempat yang sama dengan formulir, jadi membukanya mendorong keempat kartu
/// langkah turun sampai hilang dari layar — petugas kehilangan pekerjaannya
/// sendiri hanya karena ingin memastikan ia memegang sapi yang benar. Sebagai
/// lembar bawah, keterangan ini menumpang di atas halaman dan menutup tanpa
/// meninggalkan bekas, sementara daftar langkah tetap di tempatnya.
class CattleIdentitySheet extends StatelessWidget {
  const CattleIdentitySheet({
    super.key,
    required this.earTag,
    required this.rfid,
    required this.status,
    required this.items,
  });

  final String earTag;
  final String rfid;
  final String status;
  final List<ListItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.current;

    /// Urutan bagian ditetapkan di sini, bukan diambil dari urutan datangnya
    /// data, supaya lembar ini terbaca sama setiap kali dibuka.
    final groups = <String, List<ListItem>>{};
    for (final item in items) {
      final key = item.group.isEmpty ? 'Lainnya' : item.group;
      groups.putIfAbsent(key, () => <ListItem>[]).add(item);
    }

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.d8),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                Dimens.d20,
                0,
                Dimens.d20,
                Dimens.d28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _header(colors),
                  const SizedBox(height: Dimens.d20),
                  for (final entry in groups.entries) ...[
                    _sectionTitle(entry.key, colors),
                    const SizedBox(height: Dimens.d8),
                    _sectionBody(entry.value, colors),
                    const SizedBox(height: Dimens.d16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kepala lembar: RFID yang dibesarkan, ear tag dan status menyertainya.
  ///
  /// RFID-lah yang baru saja dipindai alat untuk membuka halaman ini, jadi ia
  /// yang paling cepat dicocokkan petugas. Ear tag sering belum ada pada sapi
  /// yang sedang didrafting — itu justru salah satu hal yang sedang diisi.
  Widget _header(AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(Dimens.d16),
      decoration: BoxDecoration(
        color: colors.mint800,
        borderRadius: BorderRadius.circular(Dimens.d20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimens.d40,
                height: Dimens.d40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(Dimens.d12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.qr_code_2_outlined,
                  size: Dimens.d20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: Dimens.d12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RFID',
                      style: TextStyles.label3().copyWith(
                        color: colors.mint300,
                      ),
                    ),
                    const SizedBox(height: Dimens.d2),
                    Text(
                      rfid.defaultValue('-'),
                      style: TextStyles.body1().copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (status.isNotEmpty)
                TagCategory(text: status, type: TagCategoryType.gamboge),
            ],
          ),
          const SizedBox(height: Dimens.d14),
          Row(
            children: [
              Icon(
                Icons.sell_outlined,
                size: Dimens.d14,
                color: colors.mint300,
              ),
              const SizedBox(width: Dimens.d6),
              Expanded(
                child: Text(
                  earTag.isEmpty ? 'Ear tag belum ditentukan' : earTag,
                  style: TextStyles.label2().copyWith(
                    color: earTag.isEmpty ? colors.mint300 : Colors.white,
                    fontWeight: earTag.isEmpty
                        ? FontWeight.w400
                        : FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, AppColors colors) {
    return Text(
      text,
      style: TextStyles.body3().copyWith(
        fontWeight: FontWeight.w600,
        color: colors.mint800,
      ),
    );
  }

  /// Satu bagian dibingkai sebagai satu bidang.
  ///
  /// Garis pemisah hanya di antara baris, tidak di tepi atas dan bawah, supaya
  /// yang terbaca adalah satu kelompok utuh — bukan deretan baris lepas yang
  /// kebetulan berdekatan.
  Widget _sectionBody(List<ListItem> rows, AppColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.d16),
        border: Border.all(color: colors.neutral300),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(height: 1, thickness: 1, color: colors.neutral300),
            _row(rows[i], colors),
          ],
        ],
      ),
    );
  }

  Widget _row(ListItem item, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.d14,
        vertical: Dimens.d12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.name,
              style: TextStyles.label2().copyWith(color: colors.neutral600),
            ),
          ),
          const SizedBox(width: Dimens.d12),
          Expanded(
            flex: 3,
            child: Text(
              item.description.defaultValue('-'),
              textAlign: TextAlign.end,
              style: TextStyles.body3().copyWith(
                fontWeight: FontWeight.w600,
                color: colors.neutral800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
