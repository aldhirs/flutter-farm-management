import 'package:dartx/dartx_io.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/sales/bloc/sales_bloc.dart';
import 'package:farm/features/sales/bloc/sales_event.dart';
import 'package:farm/features/sales/bloc/sales_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        children: [
          Text("Informasi Penjualan", style: TextStyles.heading5()),
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
          _item('Status', (widget.item.statusLabel()).orEmpty()),
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
}
