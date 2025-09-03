import 'package:dartx/dartx.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdentityFormBottomSheet extends StatefulWidget {
  const IdentityFormBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
  });

  final DraftingFormBloc bloc;
  final VoidCallback onDismiss;

  @override
  State<IdentityFormBottomSheet> createState() =>
      _IdentityFormBottomSheetState();
}

class _IdentityFormBottomSheetState extends State<IdentityFormBottomSheet> {
  final TextEditingController _earTagController = TextEditingController();
  final TextEditingController _penController = TextEditingController();

  @override
  void initState() {
    widget.bloc.add(const IdentityInit());
    _earTagController.text = widget.bloc.state.earTag.orEmpty();
    _penController.text = widget.bloc.state.selectedPen?.id ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _earTagController.dispose();
    _penController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<DraftingFormBloc, DraftingFormState>(
        listenWhen: (previous, current) =>
            previous.isIdentitySuccess != current.isIdentitySuccess,
        listener: (context, state) {
          if (state.isIdentitySuccess) {
            ToastHelper().showToast(
              context: context,
              message: 'Identitas sapi berhasil di perbarui',
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
              Text("Input Identitas Sapi", style: TextStyles.heading5()),
              const SizedBox(height: 12),
              _errorWidget(),
              const SizedBox(height: 12),
              _dropdownBarn(),
              _dropdownPen(),
              _dropdownLevel(),
              _textInputEarTag(),

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
                        widget.bloc.add(const OnSubmitIdentity());
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

  Widget _textInputEarTag() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return TextInputField(
            controller: _earTagController,
            label: 'Ear Tag',
            hintText: 'Ear Tag',
            onChanged: (value) {
              widget.bloc.add(EarTagChanged(value: value));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownBarn() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
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
                  .where((item) => item.name == value.first)
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
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return DropdownViewField(
            controller: _penController,
            title: 'Pilih Pen',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.pens
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id,
                      text: item.name,
                      selected: item.id == state.selectedPen?.id,
                      notes: 'Kapasitas: ${item.cattle_count}/${item.capacity}',
                      color: item.cattleToCapacityColor(),
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            sheetSize: BottomSheetSize.full,
            emptyStateMessage: 'Pilih kandang terlebih dahulu.',
            onSelectedItems: (List<String> value) {
              final selected = state.pens
                  .where((item) => item.name == value.first)
                  .first;
              widget.bloc.add(PenChanged(pen: selected));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownLevel() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return DropdownViewField(
            title: 'Pilih Grade',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.levels
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id.toString(),
                      text: item.name,
                      selected: item.id == state.selectedLevel?.id,
                      notes:
                          'Estimasi Penggemukan: ${item.estimation_day} Hari',
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.levels
                  .where((item) => item.name == value.first)
                  .first;
              widget.bloc.add(LevelChanged(value: selected));
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
        buildWhen: (p, c) => p.identityErrorMessage != c.identityErrorMessage,
        builder: (context, state) {
          return Visibility(
            visible: state.identityErrorMessage.isNotEmpty,
            child: TickerView(
              type: TickerViewType.danger,
              message: state.identityErrorMessage,
            ),
          );
        },
      ),
    );
  }
}
