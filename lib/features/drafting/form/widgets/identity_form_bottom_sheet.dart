import 'package:dartx/dartx.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/extensions/int.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_pen_field.dart';
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
  late final ValueNotifier<List<DropdownCheckboxModel>> _barnItems;

  @override
  void initState() {
    widget.bloc.add(const IdentityInit());
    _earTagController.text = widget.bloc.state.earTag.orEmpty();
    _penController.text = widget.bloc.state.selectedPen?.id ?? "";
    _barnItems = ValueNotifier([]);
    super.initState();
  }

  @override
  void dispose() {
    _barnItems.dispose();
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
            children: [
              Text("Input Identitas Sapi", style: TextStyles.heading5()),
              const SizedBox(height: 8),
              _errorWidget(),
              const SizedBox(height: 4),
              const TickerView(
                type: TickerViewType.info,
                message:
                    'Isi semua data sapi pada formulir di bawah, lalu tekan “Lanjut” untuk menyimpan. Menekan “Tutup” akan membatalkan penyimpanan.',
              ),
              const SizedBox(height: 16),

              _textInputEarTag(),
              const SizedBox(height: 16),
              _dropdownBarn(),
              _dropdownPen(),
              _dropdownLevel(),
              _dropdownGender(),

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
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.earbuds, color: AppColors.current.mint700),
            additionalInfo:
                "Masukkan ear tag untuk memberikan kode kepada sapi terkait.",
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
          // 🔥 jadwalkan update setelah frame, biar nggak bentrok dengan build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _barnItems.value = state.barns
                .map(
                  (item) => DropdownCheckboxModel(
                    id: item.id,
                    text: item.name,
                    selected: item.id == state.selectedBarn?.id,
                    notes: item.category,
                  ),
                )
                .toList();
          });
          return DropdownViewField(
            title: 'Kandang',
            items: _barnItems,
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            showSearchBar: true,
            searchHint: "cari minimal 3 karakter",
            doOnKeywordSearch: (keyword) {
              widget.bloc.add(GetBarns(search: keyword));
            },
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
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
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
            emptyStateMessage: 'Silakan pilih pen terlebih dahulu.',
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
                  .where((item) => item.id.toString() == value.first)
                  .first;
              widget.bloc.add(LevelChanged(value: selected));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownGender() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.selectedGender != c.selectedGender,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Jenis Kelamin',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              genderMap.entries
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.key,
                      text: item.value,
                      selected: item.key == state.selectedGender,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = genderMap.entries
                  .where((item) => item.key == value.first)
                  .first;
              widget.bloc.add(GenderChanged(value: selected.key));
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
