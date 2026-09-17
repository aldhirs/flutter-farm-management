import 'package:dartx/dartx.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

/// Satu ternak yang masih menunggu didrafting.
///
/// RFID yang dibesarkan, bukan ear tag.
///
/// Ternak di daftar ini justru yang belum punya nomor telinga — itulah
/// sebabnya ia ada di sini. Yang pasti dimilikinya adalah RFID dari berkas LNC
/// yang diunggah, dan RFID itu pula yang akan dipindai petugas untuk membuka
/// formulirnya. Menjadikan ear tag sebagai judul akan membuat sebagian besar
/// kartu berkepala tanda hubung.
class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.cattle, required this.onTap});

  final Cattle cattle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasEarTag = cattle.ear_tag.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.d16),
      splashColor: AppColors.current.mint400.withValues(alpha: 80),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Dimens.d12,
          vertical: Dimens.d6,
        ),
        padding: const EdgeInsets.all(Dimens.d14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.d16),
          border: Border.all(color: AppColors.current.neutral300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Dimens.d10),
              decoration: BoxDecoration(
                color: AppColors.current.mint200,
                borderRadius: BorderRadius.circular(Dimens.d12),
              ),
              child: Icon(
                Icons.qr_code_2_outlined,
                size: Dimens.d20,
                color: AppColors.current.mint700,
              ),
            ),
            const SizedBox(width: Dimens.d12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cattle.rfid_tag.defaultValue('-'),
                    style: TextStyles.body2().copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.current.mint800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimens.d6),

                  /// Ear tag muncul hanya bila memang sudah ada.
                  ///
                  /// Bila belum, ketiadaannya ditandai — bukan ditulis sebagai
                  /// tanda hubung, karena itulah justru pekerjaan yang menunggu
                  /// di kartu ini.
                  if (hasEarTag)
                    Row(
                      children: [
                        Icon(
                          Icons.sell_outlined,
                          size: Dimens.d14,
                          color: AppColors.current.neutral600,
                        ),
                        const SizedBox(width: Dimens.d6),
                        Expanded(
                          child: Text(
                            cattle.ear_tag,
                            style: TextStyles.label2().copyWith(
                              color: AppColors.current.neutral800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else
                    const TagCategory(
                      text: 'Ear tag belum ditentukan',
                      type: TagCategoryType.crismon,
                    ),

                  const SizedBox(height: Dimens.d8),
                  _source(),
                ],
              ),
            ),
            const SizedBox(width: Dimens.d8),
            Icon(
              Icons.chevron_right,
              color: AppColors.current.neutral600,
              size: Dimens.d20,
            ),
          ],
        ),
      ),
    );
  }

  /// Asal ternak: berkas LNC yang mengunggahnya, lalu ras dan supplier.
  ///
  /// Inilah satu-satunya keterangan yang dimiliki ternak sebelum didrafting,
  /// dan yang dipakai petugas memastikan ia memindai hewan dari kiriman yang
  /// benar.
  Widget _source() {
    final parts = <String>[
      (cattle.reception?.title).orEmpty(),
      cattle.id_breed,
      cattle.id_supplier,
    ].where((value) => value.isNotEmpty).toList();

    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.inventory_2_outlined,
          size: Dimens.d14,
          color: AppColors.current.neutral600,
        ),
        const SizedBox(width: Dimens.d6),
        Expanded(
          child: Text(
            parts.join(' · '),
            style: TextStyles.label3().copyWith(
              color: AppColors.current.neutral600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
