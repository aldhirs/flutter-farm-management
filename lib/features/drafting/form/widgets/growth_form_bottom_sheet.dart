import 'package:dartx/dartx.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
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
    _controller.text = widget.bloc.state.weight.orEmpty();
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
              message: 'Timbang berat sapi berhasil di perbarui',
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
              Text("Timbang Berat Sapi", style: TextStyles.heading5()),
              const SizedBox(height: 12),
              _errorWidget(),
              const SizedBox(height: 12),
              _textInputGrowth(),

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
                        widget.bloc.add(const OnSubmitGrowth());
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

  Widget _textInputGrowth() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return TextInputField(
            controller: _controller,
            label: 'Berat',
            hintText: 'Berat',
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.scale_outlined),
            customSuffixIcon: const Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16),
              child: Text('KG'),
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
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.growthErrorMessage != c.growthErrorMessage,
        builder: (context, state) {
          return Visibility(
            visible: state.growthErrorMessage.isNotEmpty,
            child: TickerView(
              type: TickerViewType.danger,
              message: state.growthErrorMessage,
            ),
          );
        },
      ),
    );
  }
}
