import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/styles/app_colors.dart';
import 'package:farm/resources/styles/text_styles.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final SalesItem item;
  final VoidCallback onTap;

  const ItemWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.current.mint400.withValues(alpha: 120),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        color: AppColors.current.neutral200,
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.ear_tag, style: TextStyles.heading5()),
                        const SizedBox(height: 4),
                        Text(item.rfid, style: TextStyles.label3()),
                      ],
                    ),
                  ),
                  TagCategory(
                    text: item.statusLabel(),
                    type: TagCategoryType.mint,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Divider
              Divider(color: Colors.grey.shade300),

              // Info items
              const SizedBox(height: 8),
              _buildDetail(Icons.scale_outlined, '${item.actual_weight} KG'),
              _buildDetail(Icons.flag, 'Sapi: ${item.cattleStatusLabel()}'),
              _buildChip(Icons.key_outlined, item.id.defaultValue('-')),
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
