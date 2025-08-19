import 'package:farm_management/core/services/parser/scale_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../cattle/data/cattle_model.dart';
import '../../core/services/bluetooth/bluetooth_controller.dart';

class WeightInputPage extends StatefulWidget {
  @override
  _WeightInputPageState createState() => _WeightInputPageState();
}

class _WeightInputPageState extends State<WeightInputPage> {
  final bluetoothController = BluetoothController();
  Cattle? selectedCattle;
  String scannedWeight = '';

  @override
  void initState() {
    super.initState();
    bluetoothController.listenToDataScale((data) {
      final weight = parseWeightFromScale(data);
      if (weight != null) {
        setState(() {
          scannedWeight = weight;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berat berhasil diterima: $weight kg')),
        );
      }
    });
  }

  @override
  void dispose() {
    bluetoothController.disconnectAll();
    super.dispose();
  }

  void connectWeighScale() async {
    try {
      final selectedDevice = await FlutterBluetoothSerial.instance.getBondedDevices().then(
            (devices) => showDialog<BluetoothDevice>(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text('Pilih Koneksi Timbangan'),
            children: devices.map((d) {
              return SimpleDialogOption(
                child: Text(d.name ?? d.address),
                onPressed: () => Navigator.pop(context, d),
              );
            }).toList(),
          ),
        ),
      );

      if (selectedDevice != null) {
        await bluetoothController.connectWeighingScale(selectedDevice, (weight) {
          print("📥 EID Diterima: $weight");
          setState(() {
            scannedWeight = weight;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('EID berhasil diterima: $weight')),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal konek ke Timbangan: $e')),
      );
    }
  }

  void weigh() {
    if (!bluetoothController.isConnectedRfid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum terhubung ke RFID scanner')),
      );
      return;
    }

    bluetoothController.listenToDataRfid((data) {
      final eid = parseWeightFromScale(data);
      if (eid != null) {
        setState(() {
          scannedWeight = eid;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('EID berhasil diterima: $eid')),
        );
      }
    });
  }

  void saveWeight() {
    if (selectedCattle != null && scannedWeight.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berat awal tersimpan untuk ${selectedCattle!.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButton<Cattle>(
            value: selectedCattle,
            hint: Text('Pilih Sapi'),
            onChanged: (value) => setState(() => selectedCattle = value),
            items: dummyCattleList.map((cattle) {
              return DropdownMenuItem(
                value: cattle,
                child: Text(cattle.name),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: connectWeighScale,
            child: Text(bluetoothController.isConnectedScale ? 'Timbangan Terhubung' : 'Connect Timbangan'),
          ),
          ElevatedButton(
            onPressed: weigh,
            child: Text('Timbang Berat'),
          ),
          Text('Berat: $scannedWeight kg'),
          ElevatedButton(
            onPressed: saveWeight,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
