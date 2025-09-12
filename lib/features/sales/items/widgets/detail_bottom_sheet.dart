import 'package:dartx/dartx_io.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

class DetailBottomSheet extends StatefulWidget {
  const DetailBottomSheet({
    super.key,
    required this.item,
    required this.onDismiss,
  });

  final Sales item;
  final VoidCallback onDismiss;

  @override
  State<DetailBottomSheet> createState() => _DetailBottomSheetState();
}

class _DetailBottomSheetState extends State<DetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.d16),
      alignment: Alignment.topLeft,
      child: Column(
        spacing: Dimens.d8,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.only(left: 16, right: 16),
            child: Text("Informasi Penjualan", style: TextStyles.heading5()),
          ),
          const SizedBox(height: 12),
          _item('ID', (widget.item.id).orEmpty()),
          _item(
            'Tanggal',
            (widget.item.created_at
                    .formatDateString(
                      format: DateConstant.UTC,
                      newFormat: DateConstant.DATETIME_FULL_MONTH,
                    )
                    .defaultValue('-'))
                .orEmpty(),
          ),
          _item('Pelanggan', (widget.item.customer_detail?.name).orEmpty()),
          _item(
            'Tipe Pelanggan',
            (widget.item.customer_detail?.type).orEmpty(),
          ),
          _itemChip(
            'Status',
            (widget.item.statusLabel()).orEmpty(),
            widget.item.statusType(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _item(String name, String value) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(name, style: TextStyles.label2()),
      subtitle: Text(value, style: TextStyles.heading6()),
    );
  }

  Widget _itemChip(String name, String value, TagCategoryType type) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyles.label2()),
          TagCategory(text: value, type: type),
        ],
      ),
    );
  }
}
