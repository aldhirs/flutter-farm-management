import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/growth_form_bottom_sheet.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GrowthFormWidget extends StatelessWidget {
  const GrowthFormWidget({
    super.key,
    required this.bloc,
    required this.navigator,
  });

  final DraftingFormBloc bloc;
  final AppNavigator navigator;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) =>
            p.isGrowthSuccess != c.isGrowthSuccess || p.loading != c.loading,
        builder: (context, state) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              navigator.showBottomSheet(
                GrowthFormBottomSheet(
                  bloc: bloc,
                  onDismiss: () => navigator.pop(),
                ),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            },
            child: Card(
              elevation: 0.3,
              color: state.isGrowthSuccess
                  ? AppColors.current.mint200
                  : AppColors.current.neutral200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.scale_outlined),
                    const SizedBox(width: 8),
                    Expanded(child: Text("Timbang", style: TextStyles.body1())),
                    Icon(
                      state.isGrowthSuccess
                          ? Icons.check_circle_outlined
                          : Icons.circle_outlined,
                      color: AppColors.current.neutral800,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
