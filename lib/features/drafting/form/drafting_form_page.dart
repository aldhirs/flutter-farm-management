import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/model/list_item.dart';
import 'package:farm/features/drafting/form/widgets/identity_form_widget.dart';
import 'package:farm/features/drafting/form/widgets/growth_form_widget.dart';
import 'package:farm/features/drafting/form/widgets/medical_form_widget.dart';
import 'package:farm/features/drafting/form/widgets/treatment_form_widget.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DraftingFormPage extends StatefulWidget {
  const DraftingFormPage({super.key, this.rfid, this.cattle});

  final String? rfid;
  final Cattle? cattle;

  @override
  State<DraftingFormPage> createState() => _DraftingFormPageState();
}

class _DraftingFormPageState
    extends BasePageState<DraftingFormPage, DraftingFormBloc> {
  @override
  void initState() {
    bloc.add(Initiated(rfid: widget.rfid, cattle: widget.cattle));
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
        titleText: 'Input Drafting Sapi',
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
        buildWhen: (p, c) =>
            p.cattle != c.cattle ||
            p.loading != c.loading ||
            p.listItems != c.listItems,
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
                  const TickerView(
                    type: TickerViewType.warning,
                    message:
                        "Data hanya akan tersimpan bila formulir dilanjutkan. Menutup formulir akan membatalkan data yang telah diisi.",
                  ),
                  const SizedBox(height: 8),
                  IdentityFormWidget(bloc: bloc, navigator: navigator),
                  GrowthFormWidget(bloc: bloc, navigator: navigator),
                  TreatmentFormWidget(bloc: bloc, navigator: navigator),
                  MedicalFormWidget(bloc: bloc, navigator: navigator),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    final isNotFound = bloc.state.errorMessage.contains('record not found');
    return EmptyState(
      title: isNotFound ? 'Data tidak ditemukan' : 'Terjadi Kesalahan',
      description: isNotFound
          ? 'Data sapi tidak dapat ditemukan. Silakan buat data baru.'
          : bloc.state.errorMessage,
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Assets.images.ilCowDenied.image(
          height: Dimens.d240,
          fit: BoxFit.cover,
        ),
      ),
      isEnabledPositifButton: isNotFound,
      buttonText: isNotFound ? 'Buat Data Sapi Baru' : 'Mengerti',
      isButtonFullWidth: true,
      leftIconButton: const Icon(Icons.add, color: Colors.white),
      onPressed: () async {
        if (isNotFound) {
          final result = await navigator.push(
            AppRouteInfo.cattleCreate(rfid: widget.rfid),
          );
          if (result != null) {
            bloc.add(GetCattle(cattle: result as Cattle));
          }
        } else {
          navigator.pop();
        }
      },
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

  Widget _finishButton() {
    final isNotFound = bloc.state.errorMessage.contains('record not found');
    return FloatingActionButton.extended(
      backgroundColor: AppColors.current.eucalyptus700,
      onPressed: () => navigator.pop(),
      label: Text(
        !isNotFound ? 'Selesai' : 'Kembali',
        style: TextStyles.button2().copyWith(color: Colors.white),
      ),
      icon: Icon(
        !isNotFound ? Icons.done : Icons.chevron_left,
        color: Colors.white,
      ),
    );
  }
}
