import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/mutation/item_add/bloc/mutation_item_add_bloc.dart';
import 'package:farm/features/mutation/item_add/bloc/mutation_item_add_event.dart';
import 'package:farm/features/mutation/item_add/bloc/mutation_item_add_state.dart';
import 'package:farm/features/mutation/items/widgets/detail_bottom_sheet.dart';
import 'package:farm/features/sales/add/model/list_item.dart';
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
class MutationItemAddPage extends StatefulWidget {
  const MutationItemAddPage({
    super.key,
    required this.item,
    required this.fromManual,
    this.cattle,
    this.rfid,
    this.connection,
  });

  final Cattle? cattle;
  final String? rfid;
  final Mutation item;
  final bool fromManual;
  final BluetoothConnection? connection;

  @override
  State<MutationItemAddPage> createState() => _MutationItemAddPageState();
}

class _MutationItemAddPageState
    extends BasePageState<MutationItemAddPage, MutationItemAddBloc> {
  @override
  void initState() {
    bloc.add(
      Initiated(rfid: widget.rfid, cattle: widget.cattle, item: widget.item),
    );
    super.initState();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MutationItemAddBloc, MutationItemAddState>(
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
        BlocListener<MutationItemAddBloc, MutationItemAddState>(
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
                          "Item penjualan dengan ear tag ${state.cattle.ear_tag.defaultValue('-')} berhasil disimpan.",
                    ),
                  ],
                  positiveButtonText: "Tambah Item Penjualan Baru",
                  onNegativeButtonPressed: () async {
                    _onPreviousPage();
                  },
                  onPositiveButtonPressed: () async {
                    _onPreviousPage();
                  },
                ),
              );
            }
          },
        ),
        BlocListener<MutationItemAddBloc, MutationItemAddState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) {
            if (state.cattle.id.isNotEmpty &&
                !state.cattle.isStatusAvailable()) {
              navigator.showAppDialog(
                useRootNavigator: true,
                barrierDismissible: false,
                Popup(
                  title: 'Tidak dapat dilanjutkan',
                  illustration: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // adjust radius
                    child: Assets.images.ilCowDenied.image(
                      height: Dimens.d240,
                      fit: BoxFit.cover,
                    ),
                  ),
                  description: [
                    const TextSpan(
                      text: 'Data sapi ini tidak tersedia atau sudah dipesan.',
                    ),
                  ],
                  positiveButtonText: "Mengerti",
                  onNegativeButtonPressed: () async {
                    _onPreviousPage();
                  },
                  onPositiveButtonPressed: () async {
                    _onPreviousPage();
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
        titleText: 'Input Item Mutasi Sapi',
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
      child: BlocBuilder<MutationItemAddBloc, MutationItemAddState>(
        buildWhen: (p, c) =>
            p.cattle != c.cattle ||
            p.loading != c.loading ||
            p.listItems != c.listItems,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsetsGeometry.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailBottomSheet(item: state.item, onDismiss: () {}),
                        Padding(
                          padding: const EdgeInsetsGeometry.only(
                            left: 8,
                            right: 8,
                            bottom: 16,
                          ),
                          child: _animalIdentityWidget(state),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _finishButton(),
            ],
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
          ? 'Data sapi tidak dapat ditemukan.'
          : bloc.state.errorMessage,
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(20), // adjust radius
        child: Assets.images.ilNotFound.image(
          height: Dimens.d240,
          fit: BoxFit.contain,
        ),
      ),
      buttonText: 'Mengerti',
      isButtonFullWidth: true,
      leftIconButton: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => navigator.pop(),
    );
  }

  Widget _itemWidget(ListItem item) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(item.name, style: TextStyles.label2()),
      subtitle: Text(item.description, style: TextStyles.heading6()),
    );
  }

  Widget _animalIdentityWidget(MutationItemAddState state) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        initiallyExpanded: true,
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
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<MutationItemAddBloc, MutationItemAddState>(
        buildWhen: (p, c) => p.cattle != c.cattle,
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
              leftIcon: const Icon(Icons.add, color: Colors.white),
              text: 'Tambahkan ke Item Mutasi',
              fulLWidth: true,
              onPressed: () {
                bloc.add(const OnSubmit());
              },
            ),
          );
        },
      ),
    );
  }

  void _onPreviousPage() async {
    await navigator.pop(result: true);
    await navigator.pop(result: true);
  }
}
