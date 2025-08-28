import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class RFIDResultBottomSheet extends StatelessWidget {
  const RFIDResultBottomSheet({
    super.key,
    required this.rfid,
    required this.onTap,
    required this.onDismiss,
  });

  final String rfid;
  final Function(String rfid) onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.d16),
      alignment: Alignment.center,
      child: Column(
        spacing: Dimens.d8,
        children: [
          Text("RFID Diterima", style: TextStyles.heading4()),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // adjust radius
            child: Assets.images.ilCowScanning.image(
              height: Dimens.d200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text("Identitas", style: TextStyles.paragraph2()),
          Text(rfid, style: TextStyles.heading3()),
          const SizedBox(height: 16),
          Button(
            size: ButtonSize.extraLarge,
            fulLWidth: true,
            type: ButtonType.primary,
            text: 'Tambahkan ',
            onPressed: () {
              onTap(rfid);
            },
            rightIcon: const Icon(Icons.input, color: Colors.white),
          ),
          Button(
            fulLWidth: true,
            type: ButtonType.ghost,
            text: 'Nanti, Pindai Ulang',
            onPressed: onDismiss,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
