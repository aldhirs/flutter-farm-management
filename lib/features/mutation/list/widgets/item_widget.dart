import 'package:dartx/dartx.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/dimens/dimens.dart';
import 'package:farm/resources/styles/app_colors.dart';
import 'package:farm/resources/styles/text_styles.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Mutation item;
  final bool isIn;
  final VoidCallback onTap;

  const ItemWidget({
    super.key,
    required this.item,
    required this.isIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.current.mint400.withAlpha(120),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimens.d12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.current.neutral100,
          borderRadius: BorderRadius.circular(Dimens.d12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              children: [
                _buildBarnBox(
                  item.from_project_name.orEmpty(),
                  isIn ? Colors.green : Colors.orange,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
                _buildBarnBox(
                  item.to_project_name.orEmpty(),
                  !isIn ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),

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
          ],
        ),
      ),
    );
  }

  // ==================== BARN BOX VERTICAL ====================
  Widget _buildBarnBox(String text, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_work_outlined, color: color, size: 18),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                text,
                style: TextStyles.label2().copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.current.mint700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== DETAIL ROW ====================
  Widget _buildDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyles.label3().copyWith(color: Colors.grey.shade800),
        ),
      ],
    );
  }

  // ==================== CHIP ====================
  Widget _buildChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.lightGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.lightGreen),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyles.label3().copyWith(color: Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}
