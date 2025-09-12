import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/treatment_form_bottom_sheet.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreatmentFormWidget extends StatelessWidget {
  const TreatmentFormWidget({
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
            p.isTreatmentSuccess != c.isTreatmentSuccess ||
            p.loading != c.loading,
        builder: (context, state) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              navigator.showBottomSheet(
                TreatmentFormBottomSheet(
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
              color: state.isTreatmentSuccess
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
                    const Icon(Icons.document_scanner),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text("Treatment", style: TextStyles.body1()),
                    ),
                    Icon(
                      state.isTreatmentSuccess
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
