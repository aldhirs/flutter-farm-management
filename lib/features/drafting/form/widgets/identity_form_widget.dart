import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/identity_form_bottom_sheet.dart';
import 'package:farm/features/drafting/form/widgets/draft_step_card.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Langkah "Identitas" pada daftar drafting.
///
/// Tampilannya dipinjam dari [DraftStepCard] bersama tiga langkah lainnya;
/// yang khas di sini hanyalah bendera keadaan yang diawasi dan lembar isian
/// yang dibukanya.
class IdentityFormWidget extends StatelessWidget {
  const IdentityFormWidget({
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
            p.isIdentitySuccess != c.isIdentitySuccess ||
            p.loading != c.loading,
        builder: (context, state) {
          return DraftStepCard(
            icon: Icons.pets,
            title: 'Identitas',
            subtitle: 'Ear tag, kandang, dan pen tujuan',
            isDone: state.isIdentitySuccess,
            onTap: () {
              navigator.showBottomSheet(
                IdentityFormBottomSheet(
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
