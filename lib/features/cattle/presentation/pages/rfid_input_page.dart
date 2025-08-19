import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../../../../core/services/bluetooth/bluetooth_controller.dart';
import 'cattle_form_page.dart';
import 'package:google_fonts/google_fonts.dart';

class RfidInputPage extends StatefulWidget {
  @override
  State<RfidInputPage> createState() => _RfidInputPageState();
}

class _RfidInputPageState extends State<RfidInputPage> {
  final bluetoothController = BluetoothController();
  bool isConnecting = false;

  Future<void> _startDraftingProcess() async {
    setState(() => isConnecting = true);

    try {
      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();

      final selectedDevice = await showDialog<BluetoothDevice>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text("Pilih Device RFID"),
          children: devices.map((device) {
            return SimpleDialogOption(
              child: Text(device.name ?? device.address),
              onPressed: () => Navigator.pop(context, device),
            );
          }).toList(),
        ),
      );

      if (selectedDevice == null) {
        setState(() => isConnecting = false);
        return;
      }

      await bluetoothController.connectRFIDScanner(selectedDevice, (eid) {});

      setState(() => isConnecting = false);

      if (bluetoothController.isConnectedRfid) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CattleFormPage()),
        );
      } else {
        _showErrorDialog('Koneksi gagal ke perangkat: ${selectedDevice.name}');
      }
    } catch (e) {
      setState(() => isConnecting = false);
      _showErrorDialog('Gagal konek: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    bluetoothController.disconnectAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bluetooth_disabled, size: 80, color: themeColor),
              const SizedBox(height: 16),
              Text(
                'Belum Terhubung',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pastikan perangkat RFID scanner sudah terhubung.',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: isConnecting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.play_arrow),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    isConnecting ? 'Menghubungkan...' : 'Mulai Proses Drafting',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                // onPressed: isConnecting ? null : _startDraftingProcess,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CattleFormPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
