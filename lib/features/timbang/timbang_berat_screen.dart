import 'dart:convert';

import 'package:farm_management/core/services/parser/scale_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../device_list_dialog.dart';
import '../cattle/data/cattle_model.dart';

class TimbangBeratScreen extends StatefulWidget {
  final Cattle selectedCattle;

  const TimbangBeratScreen({super.key, required this.selectedCattle});

  @override
  State<TimbangBeratScreen> createState() => _TimbangBeratScreenState();
}

class _TimbangBeratScreenState extends State<TimbangBeratScreen> {
  String? berat;
  BluetoothConnection? connection;
  bool isConnecting = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToScale();
  }

  void _connectToScale() async {
    setState(() => isConnecting = true);

    try {
      final device = await showDeviceListDialog(context);
      if (device == null) {
        setState(() => isConnecting = false);
        return;
      }

      BluetoothConnection.toAddress(device.address).then((_connection) {
        connection = _connection;
        setState(() {
          isConnected = true;
          isConnecting = false;
        });

        connection!.input!.listen((data) {
          final message = utf8.decode(data);
          final weight = parseWeightFromScale(message);

          if (weight != null) {
            setState(() => berat = weight);
          }
        }).onDone(() {
          setState(() => isConnected = false);
        });
      });
    } catch (e) {
      setState(() => isConnecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal konek ke timbangan: $e')),
      );
    }
  }

  void _save() {
    if (berat != null) {
      // Save to API or DB
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berat awal disimpan: $berat kg")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Belum ada data berat")),
      );
    }
  }

  @override
  void dispose() {
    if (connection != null && isConnected) {
      connection!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timbang ${widget.selectedCattle.name}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isConnecting
                ? const CircularProgressIndicator()
                : Text(
              berat ?? 'Belum ada data',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isConnected ? _save : null,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
