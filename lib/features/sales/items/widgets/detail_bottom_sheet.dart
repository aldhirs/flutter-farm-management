import 'package:dartx/dartx_io.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/views/sheet_scaffold.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

class DetailBottomSheet extends StatelessWidget {
  const DetailBottomSheet({
    super.key,
    required this.item,
    required this.onDismiss,
  });

  final Sales item;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Informasi Penjualan',
      trailing: TagCategory(text: item.statusLabel(), type: item.statusType()),
      children: [
        /// Nomor penjualan, bukan id.
        ///
        /// Nomor inilah yang tertulis di surat jalan dan disebut orang lewat
        /// telepon; id-nya sebaris UUID yang tidak pernah dibaca siapa pun dan
        /// dulu duduk paling atas sebagai hal pertama yang terlihat.
        Text(
          (item.sales_number).defaultValue('-'),
          style: TextStyles.heading4().copyWith(
            color: AppColors.current.mint800,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: Dimens.d4),
        Text(
          item.created_at.formatDateString(
            format: DateConstant.UTC,
            newFormat: DateConstant.DATETIME_FULL_MONTH,
          ),
          style: TextStyles.label3().copyWith(
            color: AppColors.current.neutral800,
          ),
        ),

        const SizedBox(height: Dimens.d24),
        SheetSectionTitle('Pelanggan'),
        const SizedBox(height: Dimens.d8),
        _customerCard(),

        const SizedBox(height: Dimens.d24),
        SheetSectionTitle('Riwayat'),
        const SizedBox(height: Dimens.d12),
        _timeline(),

        const SizedBox(height: Dimens.d24),
        _idLine(),
      ],
    );
  }

  Widget _customerCard() {
    final customer = item.customer_detail;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.d16),
      decoration: BoxDecoration(
        color: AppColors.current.mint200.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(Dimens.d16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (customer?.name).defaultValue('-'),
            style: TextStyles.body2().copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.current.mint800,
            ),
          ),
          if ((customer?.type).orEmpty().isNotEmpty) ...[
            const SizedBox(height: Dimens.d8),
            TagCategory(
              text: (customer?.type).orEmpty(),
              type: TagCategoryType.plain,
            ),
          ],
          const SizedBox(height: Dimens.d12),
          _contactLine(Icons.phone_outlined, (customer?.phone).orEmpty()),
          _contactLine(Icons.place_outlined, (customer?.address).orEmpty()),
        ],
      ),
    );
  }

  /// Baris kontak hilang ketika isinya kosong.
  ///
  /// Ikon telepon di sebelah ruang kosong menjanjikan nomor yang tidak ada.
  Widget _contactLine(IconData icon, String value) {
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.d6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: Dimens.d16, color: AppColors.current.mint700),
          const SizedBox(width: Dimens.d8),
          Expanded(
            child: Text(
              value,
              style: TextStyles.label2().copyWith(
                color: AppColors.current.neutral800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Riwayat sebagai garis waktu, bukan empat baris sejenis.
  ///
  /// Penjualan memang berjalan berurutan — dibuat, diterbitkan, lalu ditutup —
  /// dan urutan itulah yang ingin diketahui orang saat membuka informasi ini.
  /// Empat ListTile yang serupa menyimpan urutan itu hanya pada posisi baris,
  /// yang tidak terbaca sebagai urutan sama sekali.
  Widget _timeline() {
    final events = <_SaleEvent>[
      _SaleEvent('Dibuat', item.created_by, item.created_at),
      if (item.issued_at.isNotEmpty)
        _SaleEvent('Diterbitkan', item.issued_by, item.issued_at),
      if (item.completed_at.isNotEmpty)
        _SaleEvent('Diselesaikan', item.completed_by, item.completed_at),
      if (item.cancelled_at.isNotEmpty)
        _SaleEvent('Dibatalkan', item.cancelled_by, item.cancelled_at),
    ];

    return Column(
      children: List.generate(events.length, (index) {
        final event = events[index];
        final bool last = index == events.length - 1;
        return SheetTimelineRow(
          label: event.label,
          actor: event.actor.defaultValue('-'),
          time: event.at.formatDateString(
            format: DateConstant.UTC,
            newFormat: DateConstant.DATETIME_FULL_MONTH,
          ),
          isLast: last,
        );
      }),
    );
  }

  /// Id disimpan paling bawah dan dibuat kecil.
  ///
  /// Ia hanya berguna ketika seseorang harus menyebutkannya ke tim teknis;
  /// sampai saat itu ia tidak perlu bersaing dengan apa pun di layar ini.
  Widget _idLine() {
    return Row(
      children: [
        Text(
          'ID',
          style: TextStyles.label4().copyWith(
            color: AppColors.current.neutral600,
          ),
        ),
        const SizedBox(width: Dimens.d8),
        Expanded(
          child: Text(
            (item.id).defaultValue('-'),
            style: TextStyles.label4().copyWith(
              color: AppColors.current.neutral600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SaleEvent {
  const _SaleEvent(this.label, this.actor, this.at);

  final String label;
  final String actor;
  final String at;
}
