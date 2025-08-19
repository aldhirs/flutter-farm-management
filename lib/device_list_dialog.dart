import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Future<BluetoothDevice?> showDeviceListDialog(BuildContext context) async {
  final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
  return await showDialog<BluetoothDevice>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text("Pilih Device"),
      children: devices.map((device) => SimpleDialogOption(
        child: Text(device.name ?? device.address),
        onPressed: () => Navigator.pop(context, device),
      )).toList(),
    ),
  );
}
