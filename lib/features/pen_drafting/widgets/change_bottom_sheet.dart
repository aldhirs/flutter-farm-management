import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/extensions/int.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_bloc.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_event.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_state.dart';
import 'package:farm/features/pen_drafting/widgets/item_widget.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
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
  final TextEditingController _barnController = TextEditingController();
  final TextEditingController _penController = TextEditingController();
  late final ValueNotifier<List<DropdownCheckboxModel>> _barnItems;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(const GetBarns());
    _barnController.text = "";
    _penController.text = "";
    _barnItems = ValueNotifier([]);
  }

  @override
  void dispose() {
    _barnItems.dispose();
    _barnController.dispose();
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
            spacing: Dimens.d2,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Pindah Pen Drafting",
                  style: TextStyles.heading5(),
                ),
              ),
              const SizedBox(height: 8),
              _errorWidget(),
              const SizedBox(height: 4),
              const TickerView(
                type: TickerViewType.info,
                message:
                    'Silakan pilih kandang terlebih dahulu kemudian pen tujuan untuk memindahkan sapi.',
              ),
              const SizedBox(height: 12),

              /// Bagian Asal
              Text("Pen Asal", style: TextStyles.label1()),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsetsGeometry.all(8),
                child: ItemWidget(
                  item: widget.item,
                  onTap: () {},
                  isPlain: true,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Icon(Icons.arrow_downward, color: Colors.grey),
              ),
              Text("Pen Tujuan", style: TextStyles.label1()),
              const SizedBox(height: 6),
              _dropdownBarn(),
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
              Button(
                fulLWidth: true,
                type: ButtonType.ghost,
                text: 'Batalkan',
                onPressed: () => widget.bloc.navigator.pop(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownBarn() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<PenDraftingBloc, PenDraftingState>(
        buildWhen: (p, c) =>
            p.barns != c.barns || p.selectedBarn != c.selectedBarn,
        builder: (context, state) {
          _barnController.text = state.selectedBarn?.name ?? "";
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
            controller: _barnController,
            title: 'Pilih Kandang',
            items: _barnItems,
            showSearchBar: true,
            searchHint: "cari minimal 3 karakter",
            doOnKeywordSearch: (keyword) {
              widget.bloc.add(GetBarns(search: keyword));
            },
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
      child: BlocBuilder<PenDraftingBloc, PenDraftingState>(
        buildWhen: (p, c) =>
            p.selectedBarn != c.selectedBarn ||
            p.dropdownPens != c.dropdownPens ||
            p.selectedPen != c.selectedPen,
        builder: (context, state) {
          _penController.text = state.selectedPen?.name ?? "";
          final total = (state.selectedPen?.capacity).defaultZero();
          final filled = (state.selectedPen?.cattle_count).defaultZero();
          final available = total - filled;
          final infoText = available < 0
              ? 'Melebihi kapasitas sapi'
              : 'Tersedia: $available ekor';

          return DropdownViewPenField(
            controller: _penController,
            enabled: state.selectedBarn != null,
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
            emptyStateMessage: state.selectedBarn == null
                ? 'Silakan pilih kandang terlebih dahulu.'
                : 'Data tidak tersedia',
            additionalInfo: state.selectedPen != null
                ? "$infoText. ($filled/$total ekor)"
                : null,
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
