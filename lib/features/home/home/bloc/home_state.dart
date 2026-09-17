import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/project/discover_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState extends BaseBlocState with _$HomeState {
  const factory HomeState({
    @Default('') String earTag,
    @Default(false) bool loading,
    @Default('') String errorMessage,
    @Default(null) Cattle? cattle,
    @Default(0) int cattleDestination,

    /// null berarti "belum ada angka untuk ditampilkan" — entah karena feedlot
    /// belum dipilih, sedang dimuat, atau gagal dimuat. Kartu Discover
    /// menampilkan tanda hubung untuk ketiganya, karena menampilkan 0 akan
    /// terbaca sebagai "tidak ada pekerjaan", yang belum tentu benar.
    @Default(null) DiscoverSummary? discoverSummary,
    @Default(false) bool discoverLoading,
  }) = _HomeState;
  const HomeState._();
}
