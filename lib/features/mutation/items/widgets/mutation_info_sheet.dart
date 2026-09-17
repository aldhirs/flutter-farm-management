import 'package:dartx/dartx_io.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/views/sheet_scaffold.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Lembar keterangan satu mutasi.
///
/// Terpisah dari `DetailBottomSheet` di berkas sebelah, yang melayani dua peran
/// sekaligus: isi lembar bawah DAN kepala berwarna di halaman item, dengan
/// warna yang dibalik lewat sebuah bendera. Menyusun ulang tampilan lembar di
/// dalam widget itu berarti ikut menyusun ulang kepala halaman yang tidak
/// diminta berubah.
class MutationInfoSheet extends StatelessWidget {
  const MutationInfoSheet({super.key, required this.item, required this.isIn});

  final Mutation item;

  /// Mutasi masuk dilihat dari feedlot ini, bukan keluar.
  final bool isIn;

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Informasi Mutasi',
      trailing: TagCategory(text: item.statusLabel(), type: item.statusType()),
      children: [
        Text(
          (item.number).defaultValue('-'),
          style: TextStyles.heading4().copyWith(
            color: AppColors.current.mint800,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: Dimens.d4),
        Text(
          item.created_at.formatDateString(
            format: DateConstant.UTC,
            newFormat: DateConstant.DATETIME_FULL_MONTH,
          ),
          style: TextStyles.label3().copyWith(
            color: AppColors.current.neutral800,
          ),
        ),

        const SizedBox(height: Dimens.d24),
        SheetSectionTitle('Perpindahan'),
        const SizedBox(height: Dimens.d8),
        _route(),

        if (item.notes.isNotEmpty) ...[
          const SizedBox(height: Dimens.d24),
          SheetSectionTitle('Catatan'),
          const SizedBox(height: Dimens.d8),
          Text(
            item.notes,
            style: TextStyles.label2().copyWith(
              color: AppColors.current.neutral800,
              height: 1.5,
            ),
          ),
        ],

        const SizedBox(height: Dimens.d24),
        SheetSectionTitle('Riwayat'),
        const SizedBox(height: Dimens.d12),
        SheetTimelineRow(
          label: 'Dibuat',
          actor: item.created_by.defaultValue('-'),
          time: item.created_at.formatDateString(
            format: DateConstant.UTC,
            newFormat: DateConstant.DATETIME_FULL_MONTH,
          ),
          isLast: true,
        ),
      ],
    );
  }

  /// Asal dan tujuan ditampilkan keduanya, bukan hanya lawan bicaranya.
  ///
  /// Kartu di halaman daftar hanya menyebut satu sisi — "Dari: X" pada mutasi
  /// masuk — karena di sana sisi lainnya sudah pasti feedlot yang sedang
  /// dibuka. Di lembar keterangan, menyebut keduanya menghilangkan keharusan
  /// mengingat sedang berdiri di mana.
  Widget _route() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.d16),
      decoration: BoxDecoration(
        color: AppColors.current.mint200.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(Dimens.d16),
      ),
      child: Column(
        children: [
          _routeEnd(
            'Asal',
            item.from_project_name.defaultValue('-'),
            highlight: !isIn,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.d8),
            child: Row(
              children: [
                SizedBox(
                  width: Dimens.d32,
                  child: Icon(
                    LucideIcons.arrowDown,
                    size: Dimens.d16,
                    color: AppColors.current.mint700,
                  ),
                ),
              ],
            ),
          ),
          _routeEnd(
            'Tujuan',
            item.to_project_name.defaultValue('-'),
            highlight: isIn,
          ),
        ],
      ),
    );
  }

  /// [highlight] menandai ujung yang merupakan feedlot yang sedang dibuka.
  Widget _routeEnd(String label, String value, {required bool highlight}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Dimens.d32,
          child: Icon(
            LucideIcons.warehouse,
            size: Dimens.d20,
            color: highlight
                ? AppColors.current.mint700
                : AppColors.current.neutral600,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.label3().copyWith(
                  color: AppColors.current.neutral600,
                ),
              ),
              Text(
                value,
                style: TextStyles.body3().copyWith(
                  fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.current.mint800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
