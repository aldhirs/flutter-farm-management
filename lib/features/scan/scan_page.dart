import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/features/scan/bloc/scan_bloc.dart';
import 'package:farm/features/scan/bloc/scan_event.dart';
import 'package:farm/features/scan/bloc/scan_state.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:permission_handler/permission_handler.dart';

const DEST_DRAFTING_DETAIL = 'drafting_detail';
const DEST_SALES_ITEM = 'sales_item';
const DEST_MUTATION_ITEM = 'mutation_item';
const DEST_CATTLE_DETAIL = 'cattle_detail';

@RoutePage()
class ScanPage extends StatefulWidget {
  const ScanPage({
    super.key,
    required this.destinationRoute,
    this.sales = const Sales(),
    this.mutation = const Mutation(),
  });

  final String destinationRoute;
  final Sales sales;
  final Mutation mutation;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends BasePageState<ScanPage, ScanBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(
      Initiated(
        sales: widget.sales,
        mutation: widget.mutation,
        route: widget.destinationRoute,
      ),
    );
  }

  Future<bool> requestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      return true; // sudah diizinkan
    }

    if (status.isDenied) {
      status = await Permission.location.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // buka setting kalau user pilih "Don't ask again"
      await openAppSettings();
      return false;
    }

    return false;
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ScanBloc, ScanState>(
          listenWhen: (previous, current) =>
              previous.isError != current.isError,
          listener: (context, state) {
            if (state.isError) {
              ToastHelper().showToast(
                context: context,
                message: state.errorMessage,
                type: ToastType.error,
              );
              bloc.add(const ClearError());
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
      canPop: true,
      // onPopInvokedWithResult: (didPop, result) {
      //   if (didPop) {
      //     navigator.pop(result: true);
      //   }
      // },
      child: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          return CommonScaffold(
            appBar: CommonAppBar(
              titleText: 'Hubungkan Bluetooth',
              forceMaterialTransparency: false,
            ),
            body: ListView(
              children: [
                _turnOnBluetoothState(),
                const Divider(),
                _scanningResults(),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _scanningButton(),
          );
        },
      ),
    );
  }

  Widget _turnOnBluetoothState() {
    return ListTile(
      title: const Text("Bluetooth"),
      subtitle: const Text("tekan untuk mengaktifkan"),
      trailing: BlocSelector<ScanBloc, ScanState, String>(
        selector: (state) => state.adapterState.name,
        builder: (context, value) {
          return Text(value, style: TextStyles.body1());
        },
      ),
      leading: const Icon(Icons.settings_bluetooth),
      onTap: () => bloc.add(const TurnOnBluetooth()),
    );
  }

  Widget _scanningResults() {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<ScanBloc, ScanState>(
        buildWhen: (previous, current) =>
            previous.scanResults != current.scanResults ||
            previous.connectionIndex != current.connectionIndex,
        builder: (context, state) {
          if (state.scanResults.isEmpty) {
            return const Center(child: Text("Perangkat belum ditemukan"));
          }
          return Column(
            children: [
              for (final (index, result) in state.scanResults.indexed)
                ListTile(
                  title: Text("${result.name ?? "???"} (${result.address})"),
                  subtitle: Text(
                    "Bondstate: ${result.bondState.name}, Device type: ${result.type.name}",
                  ),
                  trailing: index == state.connectionIndex
                      ? const CircularProgressIndicator()
                      : Text("${result.rssi} dBm"),
                  onTap: () {
                    bloc.add(TryConnection(index: index, device: result));
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  BlocBuilder<ScanBloc, ScanState> _scanningButton() {
    return BlocBuilder<ScanBloc, ScanState>(
      buildWhen: (previous, current) =>
          previous.isScanning != current.isScanning ||
          previous.adapterState != current.adapterState,
      builder: (context, state) {
        var text = state.isScanning ? "Memindai..." : "Mulai Pindai";
        final isBluetoothOn = state.adapterState == BluetoothAdapterState.on;
        if (!isBluetoothOn) {
          text = "Hidupkan Bluetooth";
        }

        return SizedBox(
          height: 60, // 👈 custom height
          width: 210, // 👈 custom width
          child: FloatingActionButton.extended(
            backgroundColor: AppColors.current.mint700,
            onPressed: () async {
              final granted = await requestLocationPermission();
              if (granted) {
                _onScanningClicked.call(isBluetoothOn);
              } else {
                ToastHelper().showToast(
                  context: context,
                  message: "Izin lokasi diperlukan untuk scan perangkat",
                  type: ToastType.warning,
                );
              }
            },
            label: Text(
              text,
              style: TextStyles.button2().copyWith(color: Colors.white),
            ),
            icon: Icon(
              state.isScanning ? Icons.bluetooth_searching : Icons.bluetooth,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _onScanningClicked(bool isTurnOn) {
    if (!isTurnOn) {
      bloc.add(const TurnOnBluetooth());
      return;
    }
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        title: 'Mulai Memindai Perangkat?',
        description: [
          const TextSpan(
            text:
                "Pastikan alat scanner hewan sudah hidup agar terdeteksi oleh pemindai di aplikasi ini.",
          ),
        ],
        positiveButtonText: "Ya, Pindai",
        negativeButtonText: "Tidak Sekarang",
        illustration: ClipRRect(
          borderRadius: BorderRadius.circular(20), // adjust radius
          child: Assets.images.ilToolsConnect.image(
            width: Dimens.d200,
            fit: BoxFit.cover,
          ),
        ),
        onNegativeButtonPressed: () => navigator.pop(),
        onPositiveButtonPressed: () async {
          navigator.pop();
          // bloc.add(const StartScanning());
          // return;
          // bypass-debug
          switch (widget.destinationRoute) {
            case DEST_DRAFTING_DETAIL:
              navigator.popAndPush(const AppRouteInfo.draftingDetail());
            case DEST_SALES_ITEM:
              navigator.popAndPush(
                AppRouteInfo.salesItemPreview(item: widget.sales),
              );
            case DEST_MUTATION_ITEM:
              navigator.popAndPush(
                AppRouteInfo.mutationItemPreview(item: widget.mutation),
              );
            case DEST_CATTLE_DETAIL:
              navigator.popAndPush(const AppRouteInfo.cattlePreview());
          }
          // bypass-debug
        },
      ),
    );
  }
}
