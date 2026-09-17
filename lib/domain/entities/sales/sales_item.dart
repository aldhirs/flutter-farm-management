import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/base/base.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item.freezed.dart';
part 'sales_item.g.dart';

@freezed
abstract class SalesItem extends BaseOutput with _$SalesItem {
  const factory SalesItem({
    @Default('') String id,
    @Default('') String id_sale,
    @Default('') String id_cattle,
    @Default('') String rfid,
    @Default('') String ear_tag,
    @Default('') String barn_name,
    @Default('') String pen_name,
    @Default('') String barn_category,
    @Default(0) int actual_weight,
    @Default('') String cattle_status,
    @Default('') String status,

    /// Menjawab "sudah berangkat atau belum" — diisi dari surat jalan.
    @JsonKey(name: 'do_status') @Default('') String doStatus,

    /// Menjawab "sudah masuk surat jalan atau belum", pertanyaan yang berbeda
    /// dari [doStatus].
    @JsonKey(name: 'on_delivery_order') @Default(false) bool onDeliveryOrder,
    @Default('') String created_by,
  }) = _SalesItem;

  const SalesItem._();

  factory SalesItem.fromJson(Map<String, dynamic> json) =>
      _$SalesItemFromJson(json);

  /// Status muat: sejauh mana ekor ini sudah berjalan menuju keluar kandang.
  ///
  /// Diturunkan dari dua kolom, bukan dibaca dari `status`. Kolom `status`
  /// disetel sekali saat item dibuat dan tidak pernah dipindahkan lagi oleh
  /// server: pada data hari ini 696 dari 702 item milik penjualan yang sudah
  /// `completed` masih berisi `available`, sehingga layar menuliskan "Tersedia"
  /// pada ternak yang sudah terjual dan terkirim.
  ///
  /// Tiga keadaan, bukan dua — mengikuti aturan yang sama dengan layar web.
  /// Yang di tengah, sudah dipesan surat jalan tetapi belum berangkat, dulu
  /// tidak punya nama di layar; tanpa nama itu ekor yang sudah dimuat terlihat
  /// sama persis dengan yang belum, dan petugas tidak punya cara tahu mengapa
  /// ia tidak lagi ditawarkan pada surat jalan berikutnya.
  SalesItemLoadStatus loadStatus() {
    if (doStatus == 'delivered') {
      return SalesItemLoadStatus.delivered;
    }
    if (onDeliveryOrder) {
      return SalesItemLoadStatus.onDeliveryOrder;
    }
    return SalesItemLoadStatus.available;
  }

  @Deprecated(
    'Kolom `status` tidak pernah dipindahkan server setelah item dibuat, '
    'sehingga ternak yang sudah terjual tetap terbaca "Tersedia". '
    'Pakai loadStatus() untuk status muat.',
  )
  String statusLabel() {
    if (status.isEmpty) return '-';
    return salesItemStatusMap[status] ?? status;
  }

  String cattleStatusLabel() {
    if (cattle_status.isEmpty) return '-';
    return cattleStatusMap[cattle_status] ?? cattle_status;
  }

  @Deprecated('Lihat catatan pada statusLabel(). Pakai loadStatus().')
  TagCategoryType statusType() {
    switch (status) {
      case AVAILABLE:
        return TagCategoryType.eucalyptus;
      case BOOKED:
        return TagCategoryType.deepLemon;
    }
    return TagCategoryType.plain;
  }
}

/// Keadaan muat satu ekor di dalam satu penjualan.
///
/// Label dan warnanya sengaja disamakan dengan layar web supaya kantor dan
/// lapangan tidak menyebut hal yang sama dengan dua nama berbeda.
enum SalesItemLoadStatus {
  available('Tersedia', TagCategoryType.eucalyptus),
  onDeliveryOrder('Masuk Surat Jalan', TagCategoryType.royalNavy),
  delivered('Terkirim', TagCategoryType.gamboge);

  const SalesItemLoadStatus(this.label, this.tagType);

  final String label;
  final TagCategoryType tagType;
}
