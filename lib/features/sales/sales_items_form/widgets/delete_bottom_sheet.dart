import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/features/sales/sales_items_form/bloc/sales_item_form_bloc.dart';
import 'package:farm/features/sales/sales_items_form/bloc/sales_item_form_event.dart';
import 'package:farm/features/sales/sales_items_form/bloc/sales_item_form_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_pen_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteBottomSheet extends StatefulWidget {
  const DeleteBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
    this.isPage = false,
  });

  final SalesItemFormBloc bloc;
  final VoidCallback onDismiss;
  final bool isPage;

  @override
  State<DeleteBottomSheet> createState() => _DeleteBottomSheetState();
}

class _DeleteBottomSheetState extends State<DeleteBottomSheet> {
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
            Text("Pilih pen terlebih dahulu", style: TextStyles.heading5()),
            Visibility(
              visible: !widget.isPage,
              child: const SizedBox(height: 12),
            ),

            _errorWidget(),
            const SizedBox(height: 12),
            _dropdownBarn(),
            _dropdownPen(),

            const SizedBox(height: 24),
            BlocProvider.value(
              value: widget.bloc,
              child: BlocBuilder<SalesItemFormBloc, SalesItemFormState>(
                buildWhen: (p, c) => p.loading != c.loading,
                builder: (context, state) {
                  return Button(
                    fulLWidth: true,
                    type: state.loading
                        ? ButtonType.disabled
                        : ButtonType.primary,
                    loading: state.loading,
                    text: 'Cari',
                    onPressed: () {
                      widget.bloc.add(const Load());
                      if (!widget.isPage) {
                        widget.bloc.navigator.pop();
                      }
                    },
                  );
                },
              ),
            ),
            Visibility(
              visible: !widget.isPage,
              child: Button(
                fulLWidth: true,
                type: ButtonType.ghost,
                text: 'Tutup',
                onPressed: widget.onDismiss,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _dropdownBarn() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<SalesItemFormBloc, SalesItemFormState>(
        buildWhen: (p, c) => p.barns != c.barns,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Kandang',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.barns
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id,
                      text: item.name,
                      selected: item.id == state.selectedBarn?.id,
                      notes: item.category,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.barns
                  .where((item) => item.id == value.first)
                  .first;
              widget.bloc.add(BarnChanged(barn: selected));
              _penController.text = "";
            },
          );
        },
      ),
    );
  }

  Widget _dropdownPen() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<SalesItemFormBloc, SalesItemFormState>(
        builder: (context, state) {
          return DropdownViewPenField(
            controller: _penController,
            title: 'Pen Tujuan',
            items: ValueNotifier<List<Pen>>(
              state.pens
                  .map(
                    (item) => item.copyWith(
                      selected: item.id == state.selectedPen?.id,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            sheetSize: BottomSheetSize.full,
            emptyStateMessage: 'Silakan pilih kandang terlebih dahulu.',
            onSelectedItems: (List<Pen> value) {
              widget.bloc.add(PenChanged(pen: value.first));
            },
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<SalesItemFormBloc, SalesItemFormState>(
        buildWhen: (p, c) => p.errorMessage != c.errorMessage,
        builder: (context, state) {
          return Visibility(
            visible: state.errorMessage.isNotEmpty,
            child: TickerView(
              type: TickerViewType.danger,
              message: state.errorMessage,
            ),
          );
        },
      ),
    );
  }
}
