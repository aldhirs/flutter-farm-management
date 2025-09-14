import 'package:farm/constants/enum_constants.dart';
import 'package:farm/features/mutation/list/bloc/mutation_list_bloc.dart';
import 'package:farm/features/mutation/list/bloc/mutation_list_event.dart';
import 'package:farm/features/mutation/list/bloc/mutation_list_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
  });

  final MutationListBloc bloc;
  final VoidCallback onDismiss;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.d16),
      alignment: Alignment.topLeft,
      child: Column(
        spacing: Dimens.d8,
        children: [
          Text("Filter", style: TextStyles.heading5()),
          const SizedBox(height: 12),
          _dropdownStatus(),
          const SizedBox(height: 24),
          Button(
            fulLWidth: true,
            type: ButtonType.primary,
            text: 'Terapkan',
            onPressed: () {
              widget.bloc.navigator.pop();
              widget.bloc.add(const LoadMutationList(withFilter: true));
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _dropdownStatus() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<MutationListBloc, MutationListState>(
        buildWhen: (p, c) => p.filterStatus != c.filterStatus,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Status',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              mutationStatusMap.values
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item,
                      text: item,
                      selected: item == state.filterStatus,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = mutationStatusMap.values
                  .where((item) => item == value.first)
                  .first;
              widget.bloc.add(FilterStatusChanged(value: selected));
            },
          );
        },
      ),
    );
  }
}
