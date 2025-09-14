import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class DetailBottomSheet extends StatelessWidget {
  const DetailBottomSheet({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.d16),
      alignment: Alignment.topLeft,
      child: Column(
        spacing: Dimens.d8,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informasi", style: TextStyles.heading5()),
          const SizedBox(height: 4),
          Text(
            "Halaman yang menampilkan daftar seluruh pen pada feedlot. Aktivitas yang dapat dilakukan selain melihat daftar seluruh pen adalah dapat memindahkan sapi dari kandang/pen ke kandang/pen yang dituju.",
            style: TextStyles.paragraph1(),
          ),
          Text(
            "Pilih pen yang pada daftar pen drafting untuk dilakukan pemindahan sapi ke kandang dan pen lainnya.",
            style: TextStyles.paragraph1(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
