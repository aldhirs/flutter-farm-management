import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/medical_form_bottom_sheet.dart';
import 'package:farm/features/drafting/form/widgets/draft_step_card.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Langkah "Medis" pada daftar drafting.
///
/// Tampilannya dipinjam dari [DraftStepCard] bersama tiga langkah lainnya, dan
/// lembarnya dibuka lewat pintu yang sama dengan ketiganya. Lembar medis
/// mengurus tingginya sendiri karena isinya paling panjang; yang membukanya
/// tidak perlu tahu soal itu.
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
          return DraftStepCard(
            icon: Icons.medical_services_outlined,
            title: 'Medis',
            subtitle: 'Pemeriksaan, status, dan indikasi penyakit',
            isDone: state.isMedicalSuccess,
            onTap: () {
              navigator.showBottomSheet(
                MedicalFormBottomSheet(
                  bloc: bloc,
                  onDismiss: () => navigator.pop(),
                ),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            },
          );
        },
      ),
    );
  }
}
