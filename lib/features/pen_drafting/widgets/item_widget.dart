import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/resources/styles/text_styles.dart';

class ItemWidget extends StatelessWidget {
  final Pen item;
  final VoidCallback onTap;

  const ItemWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final int total = item.capacity;
    final int filled = item.cattle_count;
    final int available = total - filled;

    final double percentage = total > 0 ? filled / total : 0.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header kandang + kamar
              Row(
                children: [
                  _buildCircleIcon(Icons.home_outlined, Colors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.name_barn,
                      style: TextStyles.label1().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildCircleIcon(Icons.meeting_room_outlined, Colors.indigo),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyles.label2().copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Progress bar elegan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kapasitas Terisi: ${(percentage * 100).toStringAsFixed(0)}%",
                    style: TextStyles.label3().copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            height: 10,
                            width: constraints.maxWidth * percentage,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  item.getGradientColor(),
                                  item.getGradientColor().withValues(
                                    alpha: 0.7,
                                  ),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              /// Info jumlah tersedia & total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tersedia: $available ekor",
                    style: TextStyles.label3().copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    "$filled / $total ekor",
                    style: TextStyles.label3().copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk icon dalam lingkaran
  Widget _buildCircleIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}
