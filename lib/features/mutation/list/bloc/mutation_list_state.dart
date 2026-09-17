import 'package:farm/base/base.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_list_state.freezed.dart';

@freezed
abstract class MutationListState extends BaseBlocState
    with _$MutationListState {
  const factory MutationListState({
    @Default('') String filterStatus,

    /// Filter yang BENAR-BENAR menghasilkan daftar yang sedang terlihat.
    /// Alasannya sama seperti pada daftar penjualan.
    @Default('') String appliedFilterStatus,
    @Default([]) List<Mutation> items,
    @Default('') String errorMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
    @Default(false) bool isIn,
  }) = _MutationListState;
  const MutationListState._();

  /// Filter sedang benar-benar menyaring sesuatu.
  ///
  /// Sama seperti pada daftar penjualan: 'Semua' adalah salah satu pilihan yang
  /// dipetakan ke kunci kosong, jadi "pernah dipilih" bukan ukuran yang benar.
  bool get isFilterActive => statusKeyOf(appliedFilterStatus).isNotEmpty;

  /// Kunci status untuk dikirim ke API, kosong berarti tanpa filter.
  static String statusKeyOf(String label) {
    if (label.isEmpty) {
      return '';
    }
    for (final entry in mutationStatusMap.entries) {
      if (entry.value == label) {
        return entry.key;
      }
    }
    return '';
  }
}
