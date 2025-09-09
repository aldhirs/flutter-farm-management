import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/styles/app_colors.dart';
import 'package:farm/resources/styles/text_styles.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Cattle item;
  final bool selected;
  final VoidCallback onTap;

  const ItemWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = selected
        ? AppColors.current.mint600
        : AppColors.current.neutral200;
    final selectedTextColor = selected
        ? Colors.white
        : AppColors.current.text100;
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.current.mint400.withValues(alpha: 120),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        color: selectedColor,
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
                        Text(
                          item.ear_tag,
                          style: TextStyles.heading5().copyWith(
                            color: selectedTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.rfid_tag,
                          style: TextStyles.label3().copyWith(
                            color: selectedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TagCategory(text: item.status, type: TagCategoryType.mint),
                ],
              ),

              // Info items
              const SizedBox(height: 8),
              _buildDetail(
                Icons.home_filled,
                '${item.pen?.name_barn} - ${item.pen?.name}',
                selectedTextColor,
              ),
              _buildDetail(
                Icons.scale_outlined,
                '${item.actual_weight} KG',
                selectedTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(IconData icon, String text, Color selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: selected),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14, color: selected)),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String text, Color selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: selected),
          const SizedBox(width: 10),
          TagCategory(text: text, type: TagCategoryType.plain),
        ],
      ),
    );
  }
}
