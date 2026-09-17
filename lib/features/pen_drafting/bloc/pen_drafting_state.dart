import 'package:farm/base/base.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pen_drafting_state.freezed.dart';

@freezed
abstract class PenDraftingState extends BaseBlocState with _$PenDraftingState {
  const factory PenDraftingState({
    @Default('') String filterStatus,

    /// Filter yang BENAR-BENAR menghasilkan daftar yang sedang terlihat.
    ///
    /// Dipisahkan dari [filterStatus] dengan alasan yang sama seperti pada
    /// daftar penjualan dan mutasi: nilai itu berubah begitu dropdown disentuh,
    /// sebelum Terapkan ditekan.
    @Default('') String appliedFilterStatus,
    @Default([]) List<Pen> items,
    @Default([]) List<Barn> barns,
    @Default([]) List<Pen> dropdownPens,
    @Default(null) Barn? selectedBarn,
    @Default(null) Pen? selectedPen,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default('') String errorSnackMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
    @Default(false) bool loading,
  }) = _PenDraftingState;
  const PenDraftingState._();

  /// Filter sedang benar-benar menyaring sesuatu.
  ///
  /// Berbeda dari dua layar lain, di sini [filterStatus] menyimpan KUNCI, bukan
  /// label — dan kunci untuk 'Semua' memang string kosong. Jadi "tidak kosong"
  /// sudah merupakan ukuran yang tepat di layar ini.
  bool get isFilterActive => appliedFilterStatus.isNotEmpty;

  /// Label kategori yang sedang berlaku, untuk ditampilkan di tombol filter.
  String get appliedFilterLabel =>
      barnCategoryMap[appliedFilterStatus] ?? appliedFilterStatus;
}
