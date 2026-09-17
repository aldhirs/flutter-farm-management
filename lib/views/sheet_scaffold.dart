import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

/// Rangka bersama untuk lembar bawah yang berisi keterangan.
///
/// Dipakai bersama oleh lembar informasi penjualan dan mutasi. Keduanya
/// menjawab pertanyaan yang sama bentuknya — "apa isi berkas ini, siapa yang
/// menyentuhnya, kapan" — dan sebelumnya masing-masing menyusunnya sendiri,
/// sehingga judul, jarak, dan tepi keduanya perlahan berbeda.
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final List<Widget> children;

  /// Biasanya lencana status, diletakkan sebaris dengan judul.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Tidak menggambar pegangan tarik sendiri.
          ///
          /// `BottomsheetContainer` — pembungkus yang dipasang navigator pada
          /// setiap lembar bawah — sudah menggambarnya. Menambah satu lagi di
          /// sini membuat dua pegangan bertumpuk di atas judul.
          const SizedBox(height: Dimens.d8),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                Dimens.d20,
                0,
                Dimens.d20,
                Dimens.d28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyles.body2().copyWith(
                            color: AppColors.current.neutral800,
                          ),
                        ),
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
                  const SizedBox(height: Dimens.d12),
                  ...children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Judul bagian di dalam lembar bawah.
class SheetSectionTitle extends StatelessWidget {
  const SheetSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.body3().copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.current.mint800,
      ),
    );
  }
}

/// Satu langkah pada garis waktu.
///
/// Titik dan garis penghubungnya yang menyampaikan urutan; tanpa keduanya
/// daftar kejadian hanya terbaca sebagai beberapa baris yang kebetulan
/// bertetangga.
class SheetTimelineRow extends StatelessWidget {
  const SheetTimelineRow({
    super.key,
    required this.label,
    required this.actor,
    required this.time,
    required this.isLast,
  });

  final String label;
  final String actor;
  final String time;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: Dimens.d20,
            child: Column(
              children: [
                Container(
                  width: Dimens.d10,
                  height: Dimens.d10,
                  margin: const EdgeInsets.only(top: Dimens.d4),
                  decoration: BoxDecoration(
                    color: AppColors.current.mint700,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: Dimens.d2,
                      margin: const EdgeInsets.symmetric(vertical: Dimens.d4),
                      color: AppColors.current.mint200,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Dimens.d12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : Dimens.d20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyles.body3().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.current.mint800,
                    ),
                  ),
                  const SizedBox(height: Dimens.d2),
                  Text(
                    actor,
                    style: TextStyles.label2().copyWith(
                      color: AppColors.current.neutral800,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyles.label3().copyWith(
                      color: AppColors.current.neutral600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
