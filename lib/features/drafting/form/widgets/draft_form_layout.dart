import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:flutter/material.dart';

/// Ukuran jarak baku antarbidang di seluruh formulir drafting.
///
/// Satu angka, dipakai keempat lembar isian. Sebelumnya tiap lembar memilih
/// sendiri — 0 di satu tempat, 16 di tempat lain, 18 di tempat ketiga — dan
/// selisih dua piksel itu justru yang terbaca sebagai "tidak rapi", karena
/// bidang-bidangnya seragam sehingga jaraknya yang menonjol.
const double kDraftFieldGap = Dimens.d16;

/// Kepala lembar isian: judul, pesan galat, lalu keterangan singkat.
///
/// Urutannya tetap di keempat lembar. Galat diletakkan tepat di bawah judul
/// dan di atas keterangan karena ia menjawab pertanyaan yang lebih mendesak —
/// kenapa kiriman tadi gagal — dan karena tempatnya yang tetap membuatnya
/// muncul di titik yang sama setiap kali, bukan menggeser isi formulir.
class DraftSheetHeader extends StatelessWidget {
  const DraftSheetHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.errorMessage,
    this.hint,
  });

  final String title;
  final String subtitle;
  final String errorMessage;

  /// Keterangan tambahan yang hanya berlaku pada satu lembar.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.heading5().copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.current.mint800,
          ),
        ),
        const SizedBox(height: Dimens.d4),
        Text(
          subtitle,
          style: TextStyles.label2().copyWith(
            color: AppColors.current.neutral600,
          ),
        ),
        if (errorMessage.isNotEmpty) ...[
          const SizedBox(height: Dimens.d12),
          TickerView(type: TickerViewType.danger, message: errorMessage),
        ],
        if (hint != null) ...[
          const SizedBox(height: Dimens.d12),
          TickerView(type: TickerViewType.info, message: hint!),
        ],
        const SizedBox(height: Dimens.d20),
      ],
    );
  }
}

/// Deretan bidang isian dengan jarak yang sama di antara semuanya.
///
/// Jaraknya disisipkan di sini, bukan dititipkan ke masing-masing bidang.
/// Ketika tiap bidang membawa jaraknya sendiri, menambah atau memindahkan satu
/// bidang diam-diam mengubah jarak tetangganya, dan formulir pelan-pelan jadi
/// tidak rata — persis yang terjadi sebelumnya.
class DraftFieldColumn extends StatelessWidget {
  const DraftFieldColumn({
    super.key,
    required this.children,
    this.gap = kDraftFieldGap,
  });

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) spaced.add(SizedBox(height: gap));
      spaced.add(children[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: spaced,
    );
  }
}

/// Pasangan tombol penutup lembar isian: batal di kiri, lanjut di kanan.
///
/// Sebelumnya keduanya bertumpuk selebar lembar. Dua tombol bertumpuk memakan
/// tinggi dua kali lipat, dan di lembar yang isinya panjang tinggi itu diambil
/// dari bagian yang justru sedang dikerjakan — bidang isian paling atas
/// terdorong keluar layar. Bersebelahan, keduanya memakai satu baris.
///
/// "Lanjut" duduk di kanan karena itu arah maju di sepanjang aplikasi ini, dan
/// karena ibu jari kanan sampai ke sana lebih dulu.
class DraftSheetActions extends StatelessWidget {
  const DraftSheetActions({
    super.key,
    required this.submit,
    required this.onDismiss,
    this.dismissText = 'Tutup',
  });

  /// Tombol utamanya dititipkan jadi — bukan dibangun di sini — karena
  /// keadaannya (sedang mengirim, atau tidak) hanya diketahui lembarnya.
  final Widget submit;
  final VoidCallback onDismiss;
  final String dismissText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Button(
            fulLWidth: true,
            type: ButtonType.ghost,
            text: dismissText,
            onPressed: onDismiss,
          ),
        ),
        const SizedBox(width: Dimens.d12),
        Expanded(child: submit),
      ],
    );
  }
}
