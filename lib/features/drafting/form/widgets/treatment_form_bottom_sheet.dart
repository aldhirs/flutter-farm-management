import 'package:farm/constants/date_constant.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/datepicker/date_picker_input_widget.dart';
import 'package:farm/widgets/datepicker/date_picker_view.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TreatmentFormBottomSheet extends StatefulWidget {
  const TreatmentFormBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
  });

  final DraftingFormBloc bloc;
  final VoidCallback onDismiss;

  @override
  State<TreatmentFormBottomSheet> createState() =>
      _TreatmentFormBottomSheetState();
}

class _TreatmentFormBottomSheetState extends State<TreatmentFormBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final _datePickerController = TextEditingController();

  @override
  void initState() {
    widget.bloc.add(const TreatmentInit());
    final dateValue = DateTime.now();
    _datePickerController.text = DateFormat(
      DateConstant.DATE_FULL_MONTH,
      'id_ID',
    ).format(dateValue);
    widget.bloc.add(TreatmentDateChanged(value: dateValue));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _datePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<DraftingFormBloc, DraftingFormState>(
        listenWhen: (previous, current) =>
            previous.isTreatmentSuccess != current.isTreatmentSuccess,
        listener: (context, state) {
          if (state.isTreatmentSuccess) {
            ToastHelper().showToast(
              context: context,
              message: 'Treatment sapi berhasil di perbarui',
              type: ToastType.succes,
            );
            widget.bloc.navigator.pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(Dimens.d16),
          alignment: Alignment.topLeft,
          child: Column(
            spacing: Dimens.d8,
            children: [
              Text("Input Treatment Sapi", style: TextStyles.heading5()),
              const SizedBox(height: 12),
              _errorWidget(),
              const SizedBox(height: 12),
              _dropdownType(),
              _textInputDate(),
              const SizedBox(height: 12),
              _textInputNote(),

              const SizedBox(height: 24),
              BlocProvider.value(
                value: widget.bloc,
                child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
                  buildWhen: (p, c) => p.loading != c.loading,
                  builder: (context, state) {
                    return Button(
                      fulLWidth: true,
                      type: state.loading
                          ? ButtonType.disabled
                          : ButtonType.primary,
                      loading: state.loading,
                      text: 'Lanjut',
                      onPressed: () {
                        widget.bloc.add(const OnSubmitTreatment());
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
      ),
    );
  }

  Widget _textInputDate() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return DatePickerInputWidget(
            controller: _datePickerController,
            navigator: widget.bloc.navigator,
            datePickerType: DatePickerType.datePicker,
            label: "Tanggal Treatment",
            hintText: 'Tanggal Treatment',
            datePickerLabel: 'Pilih Tanggal Treatment',
            onApplyDate: (value, datetime) {
              widget.bloc.add(TreatmentDateChanged(value: datetime));
            },
          );
        },
      ),
    );
  }

  Widget _textInputNote() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return TextInputField(
            controller: _controller,
            label: 'Keterangan',
            hintText: 'Keterangan',
            maxLines: 4,
            onChanged: (value) {
              widget.bloc.add(TreatmentNoteChanged(value: value));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownType() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.treatmentTypes != c.treatmentTypes,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Tipe Treatment',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.treatmentTypes
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id.toString(),
                      text: item.name,
                      selected: item.id == state.selectedTreatmentType?.id,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.treatmentTypes
                  .where((item) => item.name == value.first)
                  .first;
              widget.bloc.add(TreatmentTypeChanged(value: selected));
            },
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.treatmentErrorMessage != c.treatmentErrorMessage,
        builder: (context, state) {
          return Visibility(
            visible: state.treatmentErrorMessage.isNotEmpty,
            child: TickerView(
              type: TickerViewType.danger,
              message: state.treatmentErrorMessage,
            ),
          );
        },
      ),
    );
  }
}
