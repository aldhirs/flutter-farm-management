import 'package:dartx/dartx.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/dimens/dimens.dart';
import 'package:farm/resources/styles/app_colors.dart';
import 'package:farm/resources/styles/text_styles.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Sales sale;
  final VoidCallback onTap;

  const ItemWidget({super.key, required this.sale, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.d16),
      splashColor: AppColors.current.mint400.withValues(alpha: 80),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimens.d12, vertical: 6),

        /// Bidang rata dengan tepi tipis, bukan gradien putih-ke-abu dengan
        /// bayangan.
        ///
        /// Gradien itu tidak mengabarkan apa pun dan bayangannya membuat tiap
        /// kartu tampak melayang di atas yang lain — padahal semuanya sederajat.
        /// Tepi tipis memisahkan kartu dengan lebih tenang, dan menyamakannya
        /// dengan kartu di beranda dan daftar feedlot.
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.d16),
          border: Border.all(color: AppColors.current.neutral300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header: Avatar + Customer info + Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.current.mint200,
                    child: Text(
                      sale.customer_detail?.name.isNotEmpty == true
                          ? (sale.customer_detail?.name)
                                .defaultValue('-')
                                .substring(0, 1)
                          : '',
                      style: TextStyles.body1().copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.current.mint700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (sale.customer_detail?.name).orEmpty(),
                          style: TextStyles.body2().copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (sale.customer_detail?.phone).orEmpty(),
                          style: TextStyles.label3().copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TagCategory(
                    text: sale.statusLabel(),
                    type: sale.statusType(),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Nomor penjualan dinaikkan menjadi identitas kartu.
              ///
              /// Inilah yang disebut orang saat berbicara tentang satu
              /// penjualan; sebelumnya ia jadi baris terakhir, di bawah tipe
              /// pelanggan dan tanggal.
              Text(
                (sale.sales_number).defaultValue('-'),
                style: TextStyles.body2().copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.mint800,
                ),
              ),
              const SizedBox(height: 8),

              /// Ikon memakai satu warna, bukan satu warna per baris.
              ///
              /// Indigo, oranye, dan ungu pada tiga baris berturut-turut
              /// menjanjikan bahwa warnanya berarti sesuatu. Tidak.
              _buildDetail(
                Icons.category_outlined,
                (sale.customer_detail?.type).orEmpty(),
              ),
              _buildDetail(
                Icons.calendar_today_outlined,
                sale.created_at
                    .formatDateString(
                      format: DateConstant.UTC,
                      newFormat: DateConstant.DATETIME_FULL_MONTH,
                    )
                    .defaultValue('-'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(IconData icon, String text, {Color? color}) {
    final iconColor = color ?? AppColors.current.mint700;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 10, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyles.label2().copyWith(color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
