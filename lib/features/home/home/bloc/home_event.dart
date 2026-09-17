import 'dart:async';

import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

abstract class HomeEvent extends BaseBlocEvent {
  const HomeEvent();
}

@freezed
abstract class Initiated extends HomeEvent with _$Initiated {
  const factory Initiated() = _Initiated;
  const Initiated._();
}

@freezed
abstract class CheckCattleEarTag extends HomeEvent with _$CheckCattleEarTag {
  const factory CheckCattleEarTag({required int destination}) =
      _CheckCattleEarTag;

  const CheckCattleEarTag._();
}

@freezed
abstract class EarTagChanged extends HomeEvent with _$EarTagChanged {
  const factory EarTagChanged({required String value}) = _EarTagChanged;

  const EarTagChanged._();
}

@freezed
abstract class ClearData extends HomeEvent with _$ClearData {
  const factory ClearData() = _ClearData;

  const ClearData._();
}

/// Tarik-untuk-segarkan di beranda.
///
/// Sengaja bukan kelas freezed seperti event lain di berkas ini: isinya sebuah
/// Completer, yaitu pegangan sekali pakai, bukan nilai. Membandingkan dua
/// Refreshed tidak punya arti, dan menyalinnya dengan copyWith akan menghasilkan
/// dua event yang berebut menyelesaikan completer yang sama.
///
/// Dipisahkan dari [Initiated] karena pemanggilnya menunggu. RefreshIndicator
/// menahan animasinya sampai Future-nya selesai; tanpa completer, satu-satunya
/// cara mengetahui kapan pemuatan berakhir adalah menebak lewat jeda waktu, dan
/// tebakan itu akan salah persis ketika jaringan sedang lambat — saat indikator
/// justru paling perlu jujur.
class Refreshed extends HomeEvent {
  const Refreshed({this.completer});

  final Completer<void>? completer;
}
