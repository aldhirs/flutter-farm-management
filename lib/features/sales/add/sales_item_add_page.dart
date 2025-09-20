import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/sales/add/bloc/sales_item_add_bloc.dart';
import 'package:farm/features/sales/add/bloc/sales_item_add_event.dart';
import 'package:farm/features/sales/add/bloc/sales_item_add_state.dart';
import 'package:farm/features/sales/add/model/list_item.dart';
import 'package:farm/features/sales/add/widgets/form_input_widget.dart';
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
class SalesItemAddPage extends StatefulWidget {
  const SalesItemAddPage({
    super.key,
    required this.item,
    required this.fromManual,
    this.cattle,
    this.rfid,
    this.connection,
  });

  final Cattle? cattle;
  final String? rfid;
  final Sales item;
  final bool fromManual;
  final BluetoothConnection? connection;

  @override
  State<SalesItemAddPage> createState() => _SalesItemAddPageState();
}

class _SalesItemAddPageState
    extends BasePageState<SalesItemAddPage, SalesItemAddBloc> {
  @override
  void initState() {
    bloc.add(
      Initiated(rfid: widget.rfid, cattle: widget.cattle, sale: widget.item),
    );
    super.initState();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SalesItemAddBloc, SalesItemAddState>(
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
        BlocListener<SalesItemAddBloc, SalesItemAddState>(
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
        BlocListener<SalesItemAddBloc, SalesItemAddState>(
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
              return;
            }
            if (state.cattle.id.isNotEmpty &&
                (state.cattle.ear_tag.isEmpty == true ||
                    state.cattle.actual_weight <= 0)) {
              navigator.showAppDialog(
                useRootNavigator: true,
                barrierDismissible: false,
                Popup(
                  title: 'Data Sapi Ditemukan',
                  illustration: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // adjust radius
                    child: Assets.images.ilCowSuccess.image(
                      height: Dimens.d240,
                      fit: BoxFit.cover,
                    ),
                  ),
                  description: [
                    TextSpan(
                      style: TextStyle(color: Colors.black), // style default
                      children: [
                        const TextSpan(text: 'Data sapi dengan RFID '),
                        TextSpan(
                          text: state.cattle.rfid_tag,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' ini masih dalam '),
                        const TextSpan(
                          text: 'Proses Drafting',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              '. Tekan Lanjutkan jika ingin menambahkan kedalam item penjualan.',
                        ),
                      ],
                    ),
                  ],
                  negativeButtonText: "Kembali",
                  positiveButtonText: "Lanjutkan",
                  onNegativeButtonPressed: () async {
                    _onPreviousPage();
                  },
                  onPositiveButtonPressed: () async {
                    navigator.pop();
                  },
                ),
              );
              return;
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
        titleText: 'Input Item Penjualan Sapi',
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
      child: BlocBuilder<SalesItemAddBloc, SalesItemAddState>(
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
                    padding: const EdgeInsetsGeometry.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _animalIdentityWidget(state),
                        const SizedBox(height: 24),
                        Text('Lengkapi Data', style: TextStyles.body1()),
                        const SizedBox(height: 8),
                        FormInputWidget(bloc: bloc),
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
    final isNotFound = bloc.state.errorMessage.contains('record not found');
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.name,
              style: TextStyles.body2().copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              item.description.defaultValue('-'),
              textAlign: TextAlign.end,
              style: TextStyles.body2(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _animalIdentityWidget(SalesItemAddState state) {
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
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<SalesItemAddBloc, SalesItemAddState>(
        buildWhen: (p, c) =>
            p.selectedPen != c.selectedPen || p.weight != c.weight,
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
              text: 'Tambahkan ke Item Penjualan',
              fulLWidth: true,
              onPressed: () {
                if (state.selectedPen?.id.isEmpty == true ||
                    state.weight == null) {
                  navigator.showAppDialog(
                    useRootNavigator: true,
                    barrierDismissible: false,
                    Popup(
                      title: 'Tidak dapat dilanjutkan',
                      description: [
                        const TextSpan(
                          text:
                              'Lengkapi data terlebih dahulu untuk dapat menambahkan item penjualan.',
                        ),
                      ],
                      positiveButtonText: "Mengerti",
                      onNegativeButtonPressed: () => navigator.pop(),
                      onPositiveButtonPressed: () {
                        navigator.pop();
                      },
                    ),
                  );
                  return;
                }

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
