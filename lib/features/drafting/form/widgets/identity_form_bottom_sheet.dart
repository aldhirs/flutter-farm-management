import 'package:dartx/dartx.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/draft_form_layout.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_pen_field.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimens.d20,
            Dimens.d4,
            Dimens.d20,
            Dimens.d24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(),

              /// Ketiga bidang diberi jarak oleh satu pihak saja.
              ///
              /// Sebelumnya jaraknya campuran: 16 dipasang tangan antara ear
              /// tag dan kandang, sementara kandang dan pen hanya berjarak
              /// bawaan dropdown — yang besarnya bahkan berubah menurut tinggi
              /// bilah gestur ponselnya.
              const SizedBox(height: Dimens.d4),
              DraftFieldColumn(
                children: [_textInputEarTag(), _dropdownBarn(), _dropdownPen()],
              ),
              const SizedBox(height: Dimens.d24),
              DraftSheetActions(
                submit: _submitButton(),
                onDismiss: widget.onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.identityErrorMessage != c.identityErrorMessage,
        builder: (context, state) {
          return DraftSheetHeader(
            title: 'Identitas Sapi',
            subtitle: 'Beri nomor telinga dan tentukan tempat sapi ditaruh.',
            errorMessage: state.identityErrorMessage,
            hint:
                'Isi seluruh bidang lalu tekan "Lanjut" untuk menyimpan. '
                'Menekan "Tutup" membatalkan isian.',
          );
        },
      ),
    );
  }

  Widget _submitButton() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.loading != c.loading,
        builder: (context, state) {
          return Button(
            fulLWidth: true,
            type: state.loading ? ButtonType.disabled : ButtonType.primary,
            loading: state.loading,
            text: 'Lanjut',
            onPressed: () {
              widget.bloc.add(const OnSubmitIdentity());
            },
          );
        },
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
            emptyStateMessage: state.selectedBarn == null
                ? 'Silakan pilih kandang terlebih dahulu.'
                : 'Data tidak tersedia',
            additionalInfo: state.selectedPen?.getAvailableLabel(),
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
}
