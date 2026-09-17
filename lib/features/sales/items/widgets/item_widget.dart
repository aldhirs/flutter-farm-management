import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/dimens/dimens.dart';
import 'package:farm/resources/styles/app_colors.dart';
import 'package:farm/resources/styles/text_styles.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final SalesItem item;
  final VoidCallback onTap;

  const ItemWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.d16),
      splashColor: AppColors.current.mint400.withValues(alpha: 80),
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        /// Bidang rata dengan tepi tipis, seperti kartu daftar penjualan.
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
              /// Header: Ear Tag + Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Ear tag kosong ditandai, bukan ditulis sebagai "-".
                  ///
                  /// Tanda hubung terbaca seperti data yang sedang dimuat atau
                  /// kolom yang memang tidak berlaku, padahal artinya ternak ini
                  /// belum diberi nomor telinga — sesuatu yang harus dikerjakan
                  /// seseorang. Layar web menandainya merah untuk alasan yang
                  /// sama, dan memakai kalimat yang sama.
                  Expanded(
                    child: item.ear_tag.isNotEmpty
                        ? Text(
                            item.ear_tag,
                            style: TextStyles.heading6().copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: TagCategory(
                              text: 'Belum ditentukan',
                              type: TagCategoryType.crismon,
                            ),
                          ),
                  ),
                  TagCategory(
                    text: item.loadStatus().label,
                    type: item.loadStatus().tagType,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Baris kandang disembunyikan ketika ternaknya memang tidak
              /// ada di kandang mana pun.
              ///
              /// Itu keadaan yang biasa, bukan kekecualian: ternak yang sudah
              /// terkirim memang keluar dari pen, dan pada data hari ini 701
              /// dari 725 item berada dalam keadaan itu. Menampilkan ikon rumah
              /// dan ikon pintu dengan "-" di sebelahnya pada hampir setiap
              /// kartu hanya menambah dua baris yang tidak mengabarkan apa pun.
              if (item.barn_name.isNotEmpty || item.pen_name.isNotEmpty) ...[
                Row(
                  children: [
                    _buildCircleIcon(
                      Icons.home_outlined,
                      AppColors.current.mint700,
                      16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.barn_name,
                        style: TextStyles.label1().copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildCircleIcon(
                      Icons.meeting_room_outlined,
                      Colors.indigo,
                      16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.pen_name,
                        style: TextStyles.label2().copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              /// RFID
              _buildDetail(
                icon: Icons.qr_code_2_outlined,
                text: item.rfid.defaultValue('-'),
                color: Colors.indigo,
              ),

              /// Weight
              _buildDetail(
                icon: Icons.monitor_weight_outlined,
                text: "Bobot ${item.actual_weight} Kg",
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Icon dalam lingkaran lembut
  Widget _buildCircleIcon(IconData icon, Color color, double size) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: color),
    );
  }

  /// Detail row
  Widget _buildDetail({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _buildCircleIcon(icon, color, 8),
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
