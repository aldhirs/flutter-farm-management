import 'dart:convert';

import 'package:farm_management/core/services/parser/rfid_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../device_list_dialog.dart';

class ScanRFIDScreen extends StatefulWidget {
  const ScanRFIDScreen({super.key});

  @override
  State<ScanRFIDScreen> createState() => _ScanRFIDScreenState();
}

class _ScanRFIDScreenState extends State<ScanRFIDScreen> {
  String? scannedEid;
  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    _connectToRFID();
  }

  void _connectToRFID() async {
    final device = await showDeviceListDialog(context); // custom dialog
    if (device == null) return;

    BluetoothConnection.toAddress(device.address).then((_connection) {
      connection = _connection;
      connection!.input!.listen((data) {
        final message = utf8.decode(data);
        final eid = parseEidFromRFID(message); // your parser function
        setState(() => scannedEid = eid);
      });
    });
  }

  void _save() {
    if (scannedEid != null) {
      // Simpan ke database atau API
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("EID berhasil disimpan: $scannedEid")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan RFID")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(scannedEid ?? 'Belum ada data', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
