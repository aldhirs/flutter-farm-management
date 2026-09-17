import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/draft_form_layout.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GrowthFormBottomSheet extends StatefulWidget {
  const GrowthFormBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
  });

  final DraftingFormBloc bloc;
  final VoidCallback onDismiss;

  @override
  State<GrowthFormBottomSheet> createState() => _GrowthFormBottomSheetState();
}

class _GrowthFormBottomSheetState extends State<GrowthFormBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = "";
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<DraftingFormBloc, DraftingFormState>(
        listenWhen: (previous, current) =>
            previous.isGrowthSuccess != current.isGrowthSuccess,
        listener: (context, state) {
          if (state.isGrowthSuccess) {
            ToastHelper().showToast(
              context: context,
              message: 'Timbang bobot sapi berhasil di perbarui',
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
              const SizedBox(height: Dimens.d4),
              _textInputGrowth(),
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
        buildWhen: (p, c) => p.growthErrorMessage != c.growthErrorMessage,
        builder: (context, state) {
          return DraftSheetHeader(
            title: 'Timbang Bobot',
            subtitle: 'Catat bobot sapi saat masuk kandang.',
            errorMessage: state.growthErrorMessage,
            hint:
                'Isi bobot lalu tekan "Lanjut" untuk menyimpan. '
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
              widget.bloc.add(const OnSubmitGrowth());
            },
          );
        },
      ),
    );
  }

  Widget _textInputGrowth() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return TextInputField(
            controller: _controller,
            label: 'Bobot',
            hintText: 'Bobot',
            keyboardType: TextInputType.number,
            additionalInfo:
                "Masukkan angka bobot sapi (dalam kilogram) pada kolom berikut.",
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
}
