import 'package:dartx/dartx_io.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailBottomSheet extends StatelessWidget {
  const DetailBottomSheet({
    super.key,
    required this.item,
    required this.onDismiss,
    this.isIn = false,
    this.showBottomSheet = false,
    this.isShowTitle = true,
  });

  final Mutation item;
  final VoidCallback onDismiss;
  final bool isShowTitle;
  final bool isIn;
  final bool showBottomSheet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.d16),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isShowTitle
              ? Text("Informasi Mutasi", style: TextStyles.heading5())
              : const SizedBox.shrink(),
          isShowTitle ? const SizedBox(height: 16) : const SizedBox.shrink(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildChip(Icons.key_outlined, item.number.defaultValue('-')),
              Align(
                alignment: Alignment.topLeft,
                child: TagCategory(
                  text: item.statusLabel(),
                  type: item.statusType(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // KANDANG A -> KANDANG B (VERTICAL BOX)
          _buildBarnBox(
            isIn
                ? "Dari: ${item.from_project_name.orEmpty()}"
                : "Ke: ${item.to_project_name.orEmpty()}",
            showBottomSheet
                ? (isIn ? AppColors.current.mint700 : Colors.orange)
                : Colors.white,
          ),
          const SizedBox(height: 12),

          Visibility(
            visible: item.notes.isNotEmpty,
            child: Column(
              children: [
                Text(
                  item.notes,
                  style: TextStyles.label2().copyWith(
                    color: showBottomSheet
                        ? AppColors.current.neutral800
                        : Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // DETAIL INFO
          _buildDetail(
            Icons.calendar_today_outlined,
            item.created_at
                .formatDateString(
                  format: DateConstant.UTC,
                  newFormat: DateConstant.DATETIME_FULL_MONTH,
                )
                .defaultValue('-'),
          ),
          const SizedBox(height: 8),
          _buildDetail(LucideIcons.user, item.created_by.defaultValue('-')),
          Visibility(
            visible: showBottomSheet,
            child: const SizedBox(height: 12),
          ),
        ],
      ),
    );
  }

  // ==================== BARN BOX VERTICAL ====================
  Widget _buildBarnBox(String text, Color color) {
    return Row(
      children: [
        Icon(LucideIcons.warehouse, color: color, size: 28),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyles.body1().copyWith(
            fontWeight: FontWeight.bold,
            color: showBottomSheet ? AppColors.current.mint700 : Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ==================== DETAIL ROW ====================
  /// Warna teks mengikuti latar tempat widget ini dipasang.
  ///
  /// `showBottomSheet` bernilai false ketika widget ini dipakai sebagai kepala
  /// berwarna di halaman rincian mutasi — dan justru di situ dulu ia memakai
  /// hitam, sehingga tanggal dan nama pembuat duduk gelap di atas bidang ungu
  /// dan praktis tidak terbaca. Keadaan yang sebaliknya, di dalam lembar bawah
  /// berlatar putih, sudah benar sejak awal.
  Widget _buildDetail(IconData icon, String text) {
    final Color tone = showBottomSheet
        ? AppColors.current.neutral800
        : Colors.white;
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: showBottomSheet
              ? AppColors.current.mint700
              : Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 6),
        Text(text, style: TextStyles.label3().copyWith(color: tone)),
      ],
    );
  }

  // ==================== CHIP ====================
  Widget _buildChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: showBottomSheet
            ? Colors.lightGreen.withValues(alpha: 0.1)
            : Colors.white24.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: showBottomSheet ? Colors.lightGreen : Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyles.label3().copyWith(
              color: showBottomSheet ? Colors.lightGreen : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
