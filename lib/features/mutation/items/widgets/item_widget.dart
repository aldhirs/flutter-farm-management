import 'package:farm/domain/entities/mutation/mutation_item.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

// TODO
class ItemWidget extends StatelessWidget {
  final MutationItem item;
  final VoidCallback onTap;

  const ItemWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.current.mint400.withValues(alpha: 120),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimens.d10),
        decoration: BoxDecoration(
          color: AppColors.current.neutral100,
          border: BoxBorder.all(width: 2, color: AppColors.current.neutral500),
          borderRadius: BorderRadius.circular(Dimens.d10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.tag, size: 18, color: Colors.teal),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.ear_tag.defaultValue('-'),
                                style: TextStyles.heading5(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.barcode_reader,
                              size: 18,
                              color: Colors.indigo,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.rfid,
                                style: TextStyles.label2().copyWith(
                                  color: Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.monitor_weight,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Berat ${item.weight} Kg',
                                style: TextStyles.label2().copyWith(
                                  color: Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
}
