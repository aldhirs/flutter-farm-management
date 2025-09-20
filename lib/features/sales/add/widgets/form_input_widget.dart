import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/extensions/int.dart';
import 'package:farm/features/sales/add/bloc/sales_item_add_bloc.dart';
import 'package:farm/features/sales/add/bloc/sales_item_add_event.dart';
import 'package:farm/features/sales/add/bloc/sales_item_add_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_pen_field.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormInputWidget extends StatefulWidget {
  const FormInputWidget({super.key, required this.bloc});

  final SalesItemAddBloc bloc;

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  final TextEditingController _growthController = TextEditingController();

  final TextEditingController _penController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _growthController.dispose();
    _penController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          spacing: Dimens.d8,
          children: [
            const TickerView(
              type: TickerViewType.info,
              message:
                  "Pilih pen yang dituju dan input timbang ulang sapi untuk melengkapi data item penjualan sapi.",
            ),
            _errorWidget(),
            const SizedBox(height: 12),
            _dropdownBarn(),
            _dropdownPen(),
            _textInputGrowth(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _dropdownBarn() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<SalesItemAddBloc, SalesItemAddState>(
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
      child: BlocBuilder<SalesItemAddBloc, SalesItemAddState>(
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
            emptyStateMessage: state.selectedBarn == null
                ? 'Silakan pilih kandang terlebih dahulu.'
                : 'Data tidak ditemukan',
            additionalInfo: state.selectedPen != null
                ? "Tersedia: ${(state.selectedPen?.capacity).defaultZero() - (state.selectedPen?.cattle_count).defaultZero()} ekor. (${(state.selectedPen?.cattle_count).defaultZero()}/${(state.selectedPen?.capacity).defaultZero()} ekor)"
                : null,
            onSelectedItems: (List<Pen> value) {
              widget.bloc.add(PenChanged(pen: value.first));
            },
          );
        },
      ),
    );
  }

  Widget _textInputGrowth() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<SalesItemAddBloc, SalesItemAddState>(
        builder: (context, state) {
          return TextInputField(
            controller: _growthController,
            label: 'Timbang Ulang',
            hintText: 'Timbang Ulang',
            additionalInfo:
                "Masukkan angka bobot sapi (dalam kilogram) pada kolom berikut.",
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(
              Icons.monitor_weight,
              color: Colors.redAccent,
            ),
            customSuffixIcon: const Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16),
              child: Text('Kg'),
            ),
            onChanged: (value) {
              widget.bloc.add(WeightChanged(value: value));
            },
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<SalesItemAddBloc, SalesItemAddState>(
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
