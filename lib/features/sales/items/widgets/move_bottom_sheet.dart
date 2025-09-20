import 'package:farm/extensions/string.dart';
import 'package:farm/features/sales/items/bloc/sales_items_bloc.dart';
import 'package:farm/features/sales/items/bloc/sales_items_event.dart';
import 'package:farm/features/sales/items/bloc/sales_items_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoveBottomSheet extends StatefulWidget {
  const MoveBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
    this.isPage = false,
  });

  final SalesItemsBloc bloc;
  final VoidCallback onDismiss;
  final bool isPage;

  @override
  State<MoveBottomSheet> createState() => _MoveBottomSheetState();
}

class _MoveBottomSheetState extends State<MoveBottomSheet> {
  final TextEditingController _penController = TextEditingController();

  @override
  void dispose() {
    _penController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Container(
        padding: const EdgeInsets.all(Dimens.d16),
        alignment: Alignment.topLeft,
        child: Column(
          spacing: Dimens.d8,
          children: [
            Visibility(
              visible: widget.isPage,
              child: const Icon(Icons.filter_alt_outlined, size: 72),
            ),
            Text(
              "Pindah Item ke Penjualan Lain ",
              style: TextStyles.heading5(),
            ),
            Text(
              "Pilih salah satu penjualan untuk memindahkan item penjualan yang telah dipilih.",
              style: TextStyles.body2(),
            ),
            _errorWidget(),

            /// Bagian Asal
            Text("Dari Penjualan", style: TextStyles.label1()),
            _buildInfoCard(
              name: (widget.bloc.state.sales.customer_detail?.name)
                  .defaultValue('-'),
              value: widget.bloc.state.sales.id,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Icon(Icons.arrow_downward, color: Colors.grey),
              ),
            ),
            Text("Tujuan Penjualan", style: TextStyles.label1()),
            _dropdownSales(),
            const SizedBox(height: 12),
            BlocProvider.value(
              value: widget.bloc,
              child: BlocBuilder<SalesItemsBloc, SalesItemsState>(
                buildWhen: (p, c) =>
                    p.loading != c.loading || p.selectedSale != c.selectedSale,
                builder: (context, state) {
                  return Button(
                    fulLWidth: true,
                    type: state.loading
                        ? ButtonType.disabled
                        : ButtonType.primary,
                    loading: state.loading,
                    text: 'Ya, Pindahkan',
                    onPressed: () {
                      if (state.selectedSale == null) {
                        ToastHelper().showToast(
                          context: context,
                          message: "Pilih tujuan penjualan terlebih dahulu.",
                          type: ToastType.warning,
                        );
                        return;
                      }
                      widget.bloc.add(
                        OnSubmitMoveSale(items: state.selectedItems),
                      );
                      widget.bloc.navigator.pop();
                    },
                  );
                },
              ),
            ),
            Button(
              fulLWidth: true,
              type: ButtonType.ghost,
              text: 'Tutup',
              onPressed: widget.onDismiss,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _dropdownSales() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<SalesItemsBloc, SalesItemsState>(
        builder: (context, state) {
          return DropdownViewField(
            title: 'Pilih Penjualan',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.salesList
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id,
                      text: (item.customer_detail?.name).defaultValue('-'),
                      notes: item.id,
                      selected: item.id == state.selectedSale?.id,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            emptyStateMessage: 'Data tidak ditemukan',
            onSelectedItems: (List<String> value) {
              final selected = state.salesList
                  .where((item) => item.id == value.first)
                  .first;
              widget.bloc.add(SaleChanged(sale: selected));
              _penController.text = "";
            },
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<SalesItemsBloc, SalesItemsState>(
        buildWhen: (p, c) => p.errorMessage != c.errorMessage,
        builder: (context, state) {
          return Column(
            children: [
              Visibility(
                visible: state.errorMessage.isNotEmpty,
                child: TickerView(
                  type: TickerViewType.danger,
                  message: state.errorMessage,
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  /// Card untuk menampilkan info kamar asal
  Widget _buildInfoCard({required String name, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_circle_rounded,
                size: 18,
                color: Colors.teal,
              ),
              const SizedBox(width: 6),
              Expanded(child: Text(name, style: TextStyles.label1())),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.key, size: 18, color: Colors.indigo),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: TextStyles.label2().copyWith(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
