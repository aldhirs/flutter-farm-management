import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_list_request.freezed.dart';
part 'cattle_list_request.g.dart';

@freezed
abstract class CattleListRequest extends BaseInput with _$CattleListRequest {
  const factory CattleListRequest({
    @Default('') String id_pen,
    @Default('') String status,
    @Default('') String id_project,

    /// Kirim 'no' untuk hanya menampilkan ternak yang belum didrafting.
    ///
    /// Nilai yang sama menyaring hitungan kartu "Draf Sapi" di beranda, jadi
    /// angka pada kartu dan jumlah baris di daftar ini berasal dari satu
    /// aturan yang sama di server.
    @Default('') String drafted,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _CattleListRequest;
  const CattleListRequest._();

  factory CattleListRequest.fromJson(Map<String, dynamic> json) =>
      _$CattleListRequestFromJson(json);
}
