import 'package:farm/resources/resource.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (ViewUtils.screenWidth() / 2) - 24, // 2 per row
      child: Card(
        elevation: 0.1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 8),
              Text(count, style: TextStyles.heading3()),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.button3().copyWith(
                  color: AppColors.current.black50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
