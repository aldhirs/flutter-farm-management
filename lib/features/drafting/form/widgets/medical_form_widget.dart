import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/medical_form_bottom_sheet.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalFormWidget extends StatelessWidget {
  const MedicalFormWidget({
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
            p.isMedicalSuccess != c.isMedicalSuccess || p.loading != c.loading,
        builder: (context, state) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isDismissible: false,
                enableDrag: false,
                isScrollControlled:
                    true, // <- wajib untuk tinggi dinamis dan scrollable
                useSafeArea: true, // agar tidak ketutup notch / keyboard
                backgroundColor:
                    Colors.transparent, // opsional, biar bisa desain rounded
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.9, // tinggi awal 90% layar
                    minChildSize: 0.7,
                    maxChildSize: 0.95,
                    builder: (_, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: MedicalFormBottomSheet(
                          scrollController: scrollController,
                          bloc: bloc,
                          onDismiss: () => Navigator.of(context).pop(),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Card(
              elevation: 0.3,
              color: state.isMedicalSuccess
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
                    const Icon(Icons.medical_information_outlined),
                    const SizedBox(width: 8),
                    Expanded(child: Text("Medis", style: TextStyles.body1())),
                    Icon(
                      state.isMedicalSuccess
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
