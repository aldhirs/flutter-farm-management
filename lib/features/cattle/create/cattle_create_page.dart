import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_bloc.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_event.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_state.dart';
import 'package:farm/features/cattle/create/widgets/form_input_widget.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

@RoutePage()
class CattleCreatePage extends StatefulWidget {
  const CattleCreatePage({super.key, this.connection, this.rfid});

  final String? rfid;
  final BluetoothConnection? connection;

  @override
  State<CattleCreatePage> createState() => _CattleCreatePageState();
}

class _CattleCreatePageState
    extends BasePageState<CattleCreatePage, CattleCreateBloc> {
  @override
  void initState() {
    bloc.add(Initiated(rfid: widget.rfid));
    super.initState();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CattleCreateBloc, CattleCreateState>(
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
        BlocListener<CattleCreateBloc, CattleCreateState>(
          listenWhen: (previous, current) =>
              previous.isSuccess != current.isSuccess,
          listener: (context, state) {
            if (state.isSuccess == true) {
              navigator.showAppDialog(
                useRootNavigator: true,
                barrierDismissible: false,
                Popup(
                  title: 'Sukses',
                  illustration: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Assets.images.ilCowSuccess.image(
                      height: Dimens.d200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  description: [
                    TextSpan(
                      text:
                          "Data sapi dengan ear tag ${state.cattle.ear_tag.defaultValue('-')} berhasil disimpan.",
                    ),
                  ],
                  positiveButtonText: "Lanjut Proses Drafting",
                  onPositiveButtonPressed: () async {
                    bloc.add(const OnClear());
                    if (widget.rfid?.isNotEmpty == true) {
                      _onPreviousPage();
                    } else {
                      await navigator.replace(
                        AppRouteInfo.draftingForm(cattle: state.cattle),
                      );
                    }
                  },
                ),
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
        titleText: 'Tambahkan Data Sapi',
        forceMaterialTransparency: false,
      ),
      body: ResponsiveWidget(
        mobile: _contentView(ViewUtils.screenWidth(), false),
        tabletPotrait: _contentView(ViewUtils.screenWidth() * 0.4, true),
        tabletLandscape: _contentView(ViewUtils.screenWidth() * 0.3, true),
      ),
    );
  }

  Widget _contentView(double width, bool isTablet) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) =>
            p.cattle != c.cattle ||
            p.loading != c.loading ||
            p.listItems != c.listItems,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // adjust radius
                            child: Assets.images.ilCowFeedlot.image(
                              height: Dimens.d140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Lengkapi Data Sapi',
                            style: TextStyles.body1(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormInputWidget(bloc: bloc, rfid: widget.rfid),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _addButton(),
              ],
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
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(20), // adjust radius
        child: Assets.images.ilNotFound.image(
          height: Dimens.d240,
          fit: BoxFit.contain,
        ),
      ),
      description: isNotFound
          ? 'Data sapi tidak dapat ditemukan.'
          : bloc.state.errorMessage,
      buttonText: 'Mengerti',
      isButtonFullWidth: true,
      leftIconButton: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => navigator.pop(),
    );
  }

  Widget _addButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimens.d8),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ wajib biar shadow kelihatan
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08), // warna shadow
            blurRadius: 8, // seberapa blur
            spreadRadius: 0, // seberapa melebar
            offset: const Offset(0, -2), // ✅ arah ke atas
          ),
        ],
      ),
      child: Button(
        type: ButtonType.primary,
        text: "Simpan Data Sapi",
        fulLWidth: true,
        onPressed: () {
          bloc.add(const OnSubmit());
        },
      ),
    );
  }

  void _onPreviousPage() async {
    await navigator.pop(result: true);
    await navigator.pop(result: bloc.state.cattle);
  }
}
