import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_bloc.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_event.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_pen_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeBottomSheet extends StatefulWidget {
  const ChangeBottomSheet({
    super.key,
    required this.bloc,
    required this.item,
    required this.onDismiss,
  });

  final PenDraftingBloc bloc;
  final Pen item;
  final VoidCallback onDismiss;

  @override
  State<ChangeBottomSheet> createState() => _ChangeBottomSheetState();
}

class _ChangeBottomSheetState extends State<ChangeBottomSheet> {
  final TextEditingController _penController = TextEditingController();

  @override
  void initState() {
    widget.bloc.add(const GetPens());
    super.initState();
  }

  @override
  void dispose() {
    _penController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<PenDraftingBloc, PenDraftingState>(
        listenWhen: (previous, current) =>
            previous.successMessage != current.successMessage,
        listener: (context, state) {
          if (state.successMessage.isNotEmpty) {
            ToastHelper().showToast(
              context: context,
              message: state.successMessage,
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
              Text("Pindah Pen Drafting", style: TextStyles.heading5()),
              const SizedBox(height: 12),
              _errorWidget(),

              /// Bagian Asal
              Text("Dari", style: TextStyles.label1()),
              _buildInfoCard(
                barn: widget.item.name_barn,
                room: widget.item.name,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Icon(Icons.arrow_downward, color: Colors.grey),
                ),
              ),
              Text("Tujuan", style: TextStyles.label1()),
              const SizedBox(height: 6),
              _dropdownPen(),
              const SizedBox(height: 16),
              BlocProvider.value(
                value: widget.bloc,
                child: BlocBuilder<PenDraftingBloc, PenDraftingState>(
                  buildWhen: (p, c) => p.loading != c.loading,
                  builder: (context, state) {
                    return Button(
                      fulLWidth: true,
                      type: state.loading
                          ? ButtonType.disabled
                          : ButtonType.primary,
                      loading: state.loading,
                      text: 'Pindahkan',
                      onPressed: () {
                        widget.bloc.add(
                          OnSubmitMoveToPen(fromPen: widget.item),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownPen() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<PenDraftingBloc, PenDraftingState>(
        builder: (context, state) {
          return DropdownViewPenField(
            controller: _penController,
            title: 'Pen Tujuan',
            items: ValueNotifier<List<Pen>>(
              state.dropdownPens
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
            onSelectedItems: (List<Pen> value) {
              widget.bloc.add(PenChanged(pen: value.first));
            },
          );
        },
      ),
    );
  }

  /// Card untuk menampilkan info kamar asal
  Widget _buildInfoCard({required String barn, required String room}) {
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
              const Icon(Icons.home_outlined, size: 18, color: Colors.teal),
              const SizedBox(width: 6),
              Expanded(child: Text(barn, style: TextStyles.label1())),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.meeting_room_outlined,
                size: 18,
                color: Colors.indigo,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  room,
                  style: TextStyles.label2().copyWith(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<PenDraftingBloc, PenDraftingState>(
        buildWhen: (p, c) => p.errorSnackMessage != c.errorSnackMessage,
        builder: (context, state) {
          return Visibility(
            visible: state.errorSnackMessage.isNotEmpty,
            child: Column(
              children: [
                TickerView(
                  type: TickerViewType.danger,
                  message: state.errorSnackMessage,
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
