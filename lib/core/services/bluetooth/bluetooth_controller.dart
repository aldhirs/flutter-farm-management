import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothController {
  BluetoothConnection? _rfidConnection;
  BluetoothConnection? _weighingConnection;

  bool get isRFIDConnected => _rfidConnection?.isConnected ?? false;
  bool get isWeighingConnected => _weighingConnection?.isConnected ?? false;

  /// Connect to RFID Scanner and listen to EID
  Future<void> connectRFIDScanner(BluetoothDevice device, Function(String eid) onEIDReceived) async {
    try {
      _rfidConnection = await BluetoothConnection.toAddress(device.address);
      print('✅ Connected to RFID Scanner: ${device.name}');
      _rfidConnection?.input?.listen((data) {
        final message = String.fromCharCodes(data).trim();
        print('📩 Converted Message: $message'); // Log hasil konversi
        onEIDReceived(message);
      }, onDone: () {
        print('🔌 RFID Scanner disconnected.');
      });
    } catch (e) {
      print('❌ RFID connection error: $e');
    }
  }

  /// Connect to Weighing Scale and listen to weight data
  Future<void> connectWeighingScale(BluetoothDevice device, Function(String weight) onWeightReceived) async {
    try {
      _weighingConnection = await BluetoothConnection.toAddress(device.address);
      print('✅ Connected to Weighing Scale: ${device.name}');
      _weighingConnection?.input?.listen((data) {
        final message = String.fromCharCodes(data).trim();
        if (message.startsWith('WEIGHT:')) {
          final weightStr = message.replaceFirst('WEIGHT:', '').trim();
          onWeightReceived(weightStr);
        }
      }, onDone: () {
        print('🔌 Weighing Scale disconnected.');
      });
    } catch (e) {
      print('❌ Weighing scale connection error: $e');
    }
  }

  // Getter untuk cek apakah terkoneksi
  bool get isConnectedRfid => _rfidConnection != null && _rfidConnection!.isConnected;
  bool get isConnectedScale => _weighingConnection != null && _weighingConnection!.isConnected;

  // Mendengarkan data masuk (alternatif bila tidak ingin auto-listen saat connect)
  void listenToDataRfid(Function(String) onDataReceived) {
    if (_rfidConnection != null && _rfidConnection!.isConnected) {
      _rfidConnection!.input!.listen((Uint8List data) {
        final message = utf8.decode(data);
        onDataReceived(message);
      });
    }
  }

  void listenToDataScale(Function(String) onDataReceived) {
    if (_weighingConnection != null && _weighingConnection!.isConnected) {
      _weighingConnection!.input!.listen((Uint8List data) {
        final message = utf8.decode(data);
        onDataReceived(message);
      });
    }
  }

  void disconnectAll() {
    _rfidConnection?.dispose();
    _weighingConnection?.dispose();
    _rfidConnection = null;
    _weighingConnection = null;
  }
}
