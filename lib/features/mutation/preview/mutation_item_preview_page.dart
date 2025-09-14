import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/features/mutation/items/widgets/detail_bottom_sheet.dart';
import 'package:farm/features/mutation/preview/bloc/mutation_item_preview_bloc.dart';
import 'package:farm/features/mutation/preview/bloc/mutation_item_preview_event.dart';
import 'package:farm/features/mutation/preview/bloc/mutation_item_preview_state.dart';
import 'package:farm/features/mutation/preview/widgets/result_cattle_bottom_sheet.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:vibration/vibration.dart';

@RoutePage()
class MutationItemPreviewPage extends StatefulWidget {
  const MutationItemPreviewPage({
    super.key,
    required this.item,
    this.connection,
  });

  final BluetoothConnection? connection;
  final Mutation item;

  @override
  State<MutationItemPreviewPage> createState() =>
      _MutationItemPreviewPageState();
}

class _MutationItemPreviewPageState
    extends BasePageState<MutationItemPreviewPage, MutationItemPreviewBloc> {
  @override
  void initState() {
    bloc.add(Initiated(connection: widget.connection, mutation: widget.item));
    super.initState();
  }

  @override
  void dispose() {
    widget.connection?.dispose();
    super.dispose();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MutationItemPreviewBloc, MutationItemPreviewState>(
          listenWhen: (previous, current) => previous.rfid != current.rfid,
          listener: (context, state) async {
            final currentRoute = navigator.getCurrentRouteName();
            if (state.rfid.isNotEmpty &&
                currentRoute == 'MutationItemPreviewRoute') {
              if (await Vibration.hasVibrator()) {
                Vibration.vibrate();
              }
            }
          },
        ),
        BlocListener<MutationItemPreviewBloc, MutationItemPreviewState>(
          listenWhen: (previous, current) =>
              previous.isSuccessAdd != current.isSuccessAdd,
          listener: (context, state) async {
            if (state.isSuccessAdd) {
              await navigator.pop();
              ToastHelper().showToast(
                context: context,
                message: 'Item mutasi berhasil ditambahkan.',
                type: ToastType.succes,
              );
              bloc.add(const OnClear());
            }
          },
        ),
        BlocListener<MutationItemPreviewBloc, MutationItemPreviewState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) async {
            if (state.cattle != null) {
              if (state.cattle?.isStatusAvailable() == false) {
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
                        text:
                            'Data sapi ini tidak tersedia atau sudah dipesan.',
                      ),
                    ],
                    positiveButtonText: "Mengerti",
                    onPositiveButtonPressed: () async {
                      navigator.pop();
                    },
                  ),
                );
                return;
              }

              navigator.showBottomSheet(
                isScrollControlled: true,
                ResultCattleBottomSheet(
                  bloc: bloc,
                  onTap: () async {
                    bloc.add(const OnSubmitAdd());
                  },
                  onDismiss: () => navigator.pop(),
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
    return PopScope(
      canPop: false, // prevent auto pop
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // sudah dipop, gak usah handle lagi

        final shouldPop = await _showConfirmDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop(result); // manual pop + kirim result
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MutationItemPreviewBloc>(
            create: (BuildContext context) => bloc,
          ),
        ],
        child: CommonScaffold(
          appBar: CommonAppBar(
            titleText: 'Tambah Item Mutasi',
            forceMaterialTransparency: false,
          ),
          body: ResponsiveWidget(
            mobile: _contentView(ViewUtils.screenWidth(), false),
            tabletPotrait: _contentView(ViewUtils.screenWidth() * 0.4, true),
            tabletLandscape: _contentView(ViewUtils.screenWidth() * 0.3, true),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(
    MutationItemPreviewState state,
    double width,
    bool isTablet,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: isTablet ? Dimens.d64 : 0),
        SizedBox(
          width: DeviceUtils.getDeviceType() == DeviceType.mobile
              ? width * 0.6
              : width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // adjust radius
            child: Assets.images.ilCowScanning.image(
              height: Dimens.d180,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: width,
          padding: const EdgeInsets.only(top: Dimens.d16),
          child: Text(
            'Tambah Item Mutasi',
            textAlign: TextAlign.center,
            style: TextStyles.heading4().copyWith(
              color: AppColors.current.mint800,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: width,
          child: Text(
            'Perangkat telah terhubung, Silakan untuk memindai menggunakan alat secara langsung yang selanjutnya akan ditangkap oleh aplikasi.',
            textAlign: TextAlign.center,
            style: TextStyles.paragraph1(),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            const SizedBox(height: Dimens.d16),
            _button(),
          ],
        ),
      ],
    );
  }

  Widget _received(
    MutationItemPreviewState state,
    double width,
    bool isTablet,
  ) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: !isTablet ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(height: isTablet ? Dimens.d64 : 0),
          SizedBox(
            width: DeviceUtils.getDeviceType() == DeviceType.mobile
                ? width * 0.6
                : width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // adjust radius
              child: Assets.images.ilRfidResult.image(
                height: Dimens.d140,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: width,
            padding: const EdgeInsets.only(top: Dimens.d16),
            child: Text(
              'RFID Diterima',
              textAlign: TextAlign.center,
              style: TextStyles.heading4().copyWith(
                color: AppColors.current.mint800,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text("RFID", style: TextStyles.paragraph2()),
          Text(state.rfid, style: TextStyles.heading4()),
          const SizedBox(height: 16),
          SizedBox(
            width: width,
            child: Text(
              'Silakan tekan tombol Lanjutkan untuk melakukan proses penambahan item mutasi.',
              textAlign: TextAlign.center,
              style: TextStyles.paragraph1(),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              const SizedBox(height: Dimens.d16),
              _checkRFIDButton(),
              const SizedBox(height: 16),
              Button(
                fulLWidth: true,
                type: ButtonType.ghost,
                text: 'Nanti, Pindai Ulang',
                onPressed: () {
                  bloc.add(const BottomsheetDismiss());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contentView(double width, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d16),
      child: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<MutationItemPreviewBloc, MutationItemPreviewState>(
          buildWhen: (p, c) => p.rfid != c.rfid,
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: isTablet ? Dimens.d64 : 0),
                  DetailBottomSheet(item: widget.item, onDismiss: () {}),
                  const Divider(),
                  const SizedBox(height: 16),
                  state.rfid.isNotEmpty
                      ? _received(state, width, isTablet)
                      : _emptyState(state, width, isTablet),
                  const SizedBox(height: Dimens.d16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apakah anda yakin ingin kembali?'),
        content: const Text(
          "Keluar dari halaman ini akan melepas koneksi antara aplikasi dengan alat pemindai.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // stay
            child: const Text("Tidak, tetap disini"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // allow back
            child: const Text("Ya, kembali"),
          ),
        ],
      ),
    );
    return shouldLeave ?? false;
  }

  Widget _button() {
    return Center(
      child: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<MutationItemPreviewBloc, MutationItemPreviewState>(
          buildWhen: (p, c) => p.loading != c.loading,
          builder: (context, state) {
            return Button(
              size: ButtonSize.extraLarge,
              fulLWidth: true,
              type: !state.loading ? ButtonType.primary : ButtonType.disabled,
              loading: state.loading,
              text: ' Perangkat Terhubung',
              onPressed: () {
                bloc.add(const StartScanning());
              },
              leftIcon: const Icon(
                Icons.bluetooth_connected,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _checkRFIDButton() {
    return Center(
      child: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<MutationItemPreviewBloc, MutationItemPreviewState>(
          buildWhen: (p, c) => p.loading != c.loading,
          builder: (context, state) {
            return Button(
              size: ButtonSize.extraLarge,
              fulLWidth: true,
              type: !state.loading ? ButtonType.primary : ButtonType.disabled,
              loading: state.loading,
              text: 'Lanjutkan ',
              onPressed: () async {
                bloc.add(CheckCattle(rfid: state.rfid));
              },
              rightIcon: const Icon(
                Icons.arrow_circle_right_outlined,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
