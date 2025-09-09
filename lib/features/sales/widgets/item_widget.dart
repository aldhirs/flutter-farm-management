import 'package:dartx/dartx.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/styles/app_colors.dart';
import 'package:farm/resources/styles/text_styles.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Sales sale;
  final VoidCallback onTap;

  const ItemWidget({super.key, required this.sale, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.current.mint400.withValues(alpha: 120),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.current.neutral300, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        color: Colors.white,
        shadowColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name + Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.teal.shade100,
                    child: Text(
                      sale.customer_detail?.name.isNotEmpty == true
                          ? (sale.customer_detail?.name)
                                .defaultValue('-')
                                .substring(0, 1)
                          : '',
                      style: TextStyles.body1(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (sale.customer_detail?.name).orEmpty(),
                          style: TextStyles.heading5(),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (sale.customer_detail?.id).orEmpty(),
                          style: TextStyles.label3(),
                        ),
                      ],
                    ),
                  ),
                  TagCategory(
                    text: sale.statusLabel(),
                    type: sale.statusType(),
                  ),
                ],
              ),
              // Info items
              const SizedBox(height: 8),
              _buildDetail(
                Icons.category_outlined,
                (sale.customer_detail?.type).orEmpty(),
              ),
              _buildDetail(
                Icons.calendar_today_outlined,
                sale.created_at
                    .formatDateString(
                      format: DateConstant.UTC,
                      newFormat: DateConstant.DATETIME_FULL_MONTH,
                    )
                    .defaultValue('-'),
              ),
              _buildChip(Icons.key_outlined, (sale.id).defaultValue('-')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          TagCategory(text: text, type: TagCategoryType.plain),
        ],
      ),
    );
  }
}
