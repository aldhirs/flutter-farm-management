import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/cattle/preview/bloc/cattle_preview_bloc.dart';
import 'package:farm/features/cattle/preview/bloc/cattle_preview_state.dart';
import 'package:farm/features/cattle/preview/bloc/cattle_preview_event.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:vibration/vibration.dart';

@RoutePage()
class CattlePreviewPage extends StatefulWidget {
  const CattlePreviewPage({super.key, this.connection});

  final BluetoothConnection? connection;

  @override
  State<CattlePreviewPage> createState() => _CattlePreviewPageState();
}

class _CattlePreviewPageState
    extends BasePageState<CattlePreviewPage, CattlePreviewBloc> {
  final AudioPlayer _player = AudioPlayer();
  @override
  void initState() {
    bloc.add(Initiated(connection: widget.connection));
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    widget.connection?.dispose();
    super.dispose();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CattlePreviewBloc, CattlePreviewState>(
          listenWhen: (previous, current) => previous.rfid != current.rfid,
          listener: (context, state) async {
            final currentRoute = navigator.getCurrentRouteName();
            if (state.rfid.isNotEmpty && currentRoute == 'CattlePreviewRoute') {
              if (await Vibration.hasVibrator()) {
                Vibration.vibrate();
              }
              await _player.play(AssetSource('audio/rfid_accepted.m4a'));
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
          BlocProvider<CattlePreviewBloc>(
            create: (BuildContext context) => bloc,
          ),
        ],
        child: CommonScaffold(
          appBar: CommonAppBar(
            titleText: 'Pencarian Data Sapi',
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

  Widget _emptyState(CattlePreviewState state, double width, bool isTablet) {
    return Column(
      mainAxisSize: !isTablet ? MainAxisSize.min : MainAxisSize.max,
      children: [
        SizedBox(height: isTablet ? Dimens.d64 : 0),
        SizedBox(
          width: DeviceUtils.getDeviceType() == DeviceType.mobile
              ? width * 0.7
              : width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // adjust radius
            child: Assets.images.ilCowScanning.image(
              height: Dimens.d240,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: width,
          padding: const EdgeInsets.only(top: Dimens.d16),
          child: Text(
            'Pencarian Data Sapi',
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

  Widget _received(CattlePreviewState state, double width, bool isTablet) {
    return Column(
      mainAxisSize: !isTablet ? MainAxisSize.min : MainAxisSize.max,
      children: [
        SizedBox(height: isTablet ? Dimens.d64 : 0),
        SizedBox(
          width: DeviceUtils.getDeviceType() == DeviceType.mobile
              ? width * 0.7
              : width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // adjust radius
            child: Assets.images.ilRfidResult.image(
              height: Dimens.d200,
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
            'Silakan tekan tombol Lanjutkan untuk mencari data sapi berdasarkan RFID, atau tekan Nanti, Pindai Ulang untuk melakukan proses scan sapi kembali.',
            textAlign: TextAlign.center,
            style: TextStyles.paragraph1(),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            const SizedBox(height: Dimens.d16),
            Button(
              size: ButtonSize.extraLarge,
              fulLWidth: true,
              type: ButtonType.primary,
              text: 'Lanjutkan ',
              onPressed: () {
                _onSearchResult(state.rfid);
              },
              rightIcon: const Icon(
                Icons.arrow_circle_right_outlined,
                color: Colors.white,
              ),
            ),
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
    );
  }

  Widget _contentView(double width, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d16),
      alignment: Alignment.center,
      child: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<CattlePreviewBloc, CattlePreviewState>(
          buildWhen: (p, c) => p.rfid != c.rfid,
          builder: (context, state) {
            return state.rfid.isNotEmpty
                ? _received(state, width, isTablet)
                : _emptyState(state, width, isTablet);
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

  void _onSearchResult(String value) {
    bloc.add(const BottomsheetDismiss());
    navigator.push(
      AppRouteInfo.cattleSearch(rfid: value, connection: widget.connection),
    );
  }

  Widget _button() {
    return Center(
      child: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<CattlePreviewBloc, CattlePreviewState>(
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
}
