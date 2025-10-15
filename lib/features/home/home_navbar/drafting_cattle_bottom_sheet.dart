import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_bloc.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_state.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_event.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DraftingCattleBottomSheet extends StatefulWidget {
  const DraftingCattleBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
  });

  final HomeNavBarBloc bloc;
  final VoidCallback onDismiss;

  @override
  State<DraftingCattleBottomSheet> createState() =>
      _DraftingCattleBottomSheetState();
}

class _DraftingCattleBottomSheetState extends State<DraftingCattleBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // adjust radius
              child: Assets.images.ilCowSearch.image(
                height: Dimens.d140,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text("Drafting Sapi", style: TextStyles.heading5()),
            Text("Cari sapi dengan input ear tag", style: TextStyles.body2()),
            _errorWidget(),

            _textInput(),
            const SizedBox(height: 12),
            BlocProvider.value(
              value: widget.bloc,
              child: BlocBuilder<HomeNavBarBloc, HomeNavBarState>(
                buildWhen: (p, c) =>
                    p.loading != c.loading || p.earTag != c.earTag,
                builder: (context, state) {
                  return Button(
                    fulLWidth: true,
                    type: state.loading
                        ? ButtonType.disabled
                        : ButtonType.primary,
                    loading: state.loading,
                    text: 'Cari Data Sapi',
                    leftIcon: const Icon(
                      Icons.search_outlined,
                      color: Colors.white,
                    ),
                    // bypass-debug
                    onLongPressed: () {
                      if (state.earTag.isEmpty) {
                        ToastHelper().showToast(
                          context: context,
                          message: "Input RFID terlebih dahulu",
                          type: ToastType.warning,
                        );
                        return;
                      }
                      widget.bloc.add(const CheckCattleRFID(destination: 2));
                    },
                    // bypass-debug
                    onPressed: () {
                      if (state.earTag.isEmpty) {
                        ToastHelper().showToast(
                          context: context,
                          message: "Input Ear Tag terlebih dahulu",
                          type: ToastType.warning,
                        );
                        return;
                      }
                      widget.bloc.add(const CheckCattleEarTag(destination: 2));
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

  Widget _textInput() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<HomeNavBarBloc, HomeNavBarState>(
        builder: (context, state) {
          return TextInputField(
            controller: _controller,
            label: 'Ear Tag',
            hintText: 'Masukkan Ear Tag',
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.earbuds, color: AppColors.current.mint700),
            onChanged: (value) {
              widget.bloc.add(EarTagChanged(value: value));
            },
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<HomeNavBarBloc, HomeNavBarState>(
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
}
