import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/dimens/dimens.dart';
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
      borderRadius: BorderRadius.circular(Dimens.d16),
      splashColor: AppColors.current.mint400.withValues(alpha: 80),
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(Dimens.d16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header: Ear Tag + Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.ear_tag.defaultValue('-'),
                            style: TextStyles.heading6().copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TagCategory(
                    text: item.statusLabel(),
                    type: item.statusType(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  _buildCircleIcon(Icons.home_outlined, Colors.teal, 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.barn_name.defaultValue('-'),
                      style: TextStyles.label1().copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildCircleIcon(
                    Icons.meeting_room_outlined,
                    Colors.indigo,
                    16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.pen_name.defaultValue('-'),
                      style: TextStyles.label2().copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// RFID
              _buildDetail(
                icon: Icons.qr_code_2_outlined,
                text: item.rfid.defaultValue('-'),
                color: Colors.indigo,
              ),

              /// Weight
              _buildDetail(
                icon: Icons.monitor_weight_outlined,
                text: "Bobot ${item.actual_weight} Kg",
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Icon dalam lingkaran lembut
  Widget _buildCircleIcon(IconData icon, Color color, double size) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: color),
    );
  }

  /// Detail row
  Widget _buildDetail({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _buildCircleIcon(icon, color, 8),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyles.label2().copyWith(color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
