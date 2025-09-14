import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'barn.freezed.dart';
part 'barn.g.dart';

@freezed
abstract class Barn extends BaseOutput with _$Barn {
  const factory Barn({
    @Default('') String id,
    @Default('') String name,
    @Default('') String category,
  }) = _Barn;
  const Barn._();
  factory Barn.fromJson(Map<String, dynamic> json) => _$BarnFromJson(json);
}
