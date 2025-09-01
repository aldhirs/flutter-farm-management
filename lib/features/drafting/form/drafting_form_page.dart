import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/model/list_item.dart';
import 'package:farm/features/drafting/form/widgets/identity_form_bottom_sheet.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DraftingFormPage extends StatefulWidget {
  const DraftingFormPage({super.key, required this.rfid});

  final String rfid;

  @override
  State<DraftingFormPage> createState() => _DraftingFormPageState();
}

class _DraftingFormPageState
    extends BasePageState<DraftingFormPage, DraftingFormBloc> {
  @override
  void initState() {
    bloc.add(Initiated(rfid: widget.rfid));
    super.initState();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DraftingFormBloc, DraftingFormState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              ToastHelper().showToast(
                context: context,
                message: state.errorMessage,
                type: ToastType.error,
              );
            }
          },
        ),
      ],
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(
        titleText: 'Input Drafting Hewan',
        forceMaterialTransparency: false,
      ),
      body: ResponsiveWidget(
        mobile: _contentView(ViewUtils.screenWidth(), false),
        tabletPotrait: _contentView(ViewUtils.screenWidth() * 0.4, true),
        tabletLandscape: _contentView(ViewUtils.screenWidth() * 0.3, true),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _finishButton(),
    );
  }

  Widget _contentView(double width, bool isTablet) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.cattle != c.cattle || p.loading != c.loading,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _animalIdentityWidget(state),
                  const SizedBox(height: 24),
                  Text('Perbarui Data', style: TextStyles.body1()),
                  const SizedBox(height: 8),
                  _identityFormWidget(),
                  _weightFormWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    final isNotFound = bloc.state.errorMessage == 'record not found';
    return EmptyState(
      title: isNotFound ? 'Data tidak ditemukan' : 'Terjadi Kesalahan',
      description: isNotFound
          ? 'Data tidak dapat ditemukan. Silakan buat data baru.'
          : bloc.state.errorMessage,
      imageAssets: Icon(
        Icons.warning_outlined,
        size: 140,
        color: AppColors.current.neutral800,
      ),
      isEnabledPositifButton: isNotFound,
      buttonText: isNotFound ? 'Buat Data Baru' : '',
      isButtonFullWidth: true,
      leftIconButton: const Icon(Icons.add, color: Colors.white),
      onPressed: () async {},
    );
  }

  Widget _itemWidget(ListItem item) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(item.name, style: TextStyles.label2()),
      subtitle: Text(item.description, style: TextStyles.heading6()),
    );
  }

  Widget _animalIdentityWidget(DraftingFormState state) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text("Identitas Sapi", style: TextStyles.body1()),
        subtitle: Text(
          state.cattle.ear_tag.defaultValue("-"),
          style: TextStyles.label2(),
        ),
        children: [
          ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.listItems.length,
            itemBuilder: (context, index) {
              final item = state.listItems[index];
              return _itemWidget(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _identityFormWidget() {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) =>
            p.isIdentitySuccess != c.isIdentitySuccess ||
            p.loading != c.loading,
        builder: (context, state) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              navigator.showBottomSheet(
                IdentityFormBottomSheet(
                  bloc: bloc,
                  onDismiss: () {
                    navigator.pop();
                  },
                ),
                isScrollControlled: true,
              );
            },
            child: Card(
              elevation: 0.3,
              color: state.isIdentitySuccess
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
                    const Icon(Icons.pets),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text("Identitas", style: TextStyles.body1()),
                    ),
                    Icon(
                      state.isIdentitySuccess
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

  Widget _weightFormWidget() {
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
                IdentityFormBottomSheet(
                  bloc: bloc,
                  onDismiss: () {
                    navigator.pop();
                  },
                ),
                isScrollControlled: true,
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
                    Expanded(
                      child: Text("Timbang Sapi", style: TextStyles.body1()),
                    ),
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

  Widget _finishButton() {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.current.eucalyptus700,
      onPressed: () {
        navigator.pop();
      },
      label: Text(
        'Selesai',
        style: TextStyles.button2().copyWith(color: Colors.white),
      ),
      icon: const Icon(Icons.done, color: Colors.white),
    );
  }
}
