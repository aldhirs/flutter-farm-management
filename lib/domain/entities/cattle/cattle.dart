import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle.freezed.dart';
part 'cattle.g.dart';

@freezed
abstract class Cattle extends BaseOutput with _$Cattle {
  const factory Cattle({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'id_project') @Default('') String id_project,
    @JsonKey(name: 'project_name') @Default('') String project_name,
    @JsonKey(name: 'id_breed') @Default('') String id_breed,
    @JsonKey(name: 'id_supplier') @Default('') String id_supplier,
    @JsonKey(name: 'id_station') @Default('') String id_station,
    @JsonKey(name: 'rfid_tag') @Default('') String rfid_tag,
    @JsonKey(name: 'ear_tag') @Default('') String ear_tag,
    @JsonKey(name: 'initial_weight') @Default(0) int initial_weight,
    @JsonKey(name: 'actual_weight') @Default(0) int actual_weight,
    @JsonKey(name: 'initial_price') @Default(0) double initial_price,
    @JsonKey(name: 'birth_date') @Default('') String birth_date,
    @JsonKey(name: 'gender') @Default('') String gender,
    @JsonKey(name: 'status') @Default('') String status,
    @JsonKey(name: 'medical_notes') @Default('') String medical_notes,
    @JsonKey(name: 'created_at') @Default('') String created_at,
    @JsonKey(name: 'updated_at') @Default('') String updated_at,
    @JsonKey(name: 'created_by') @Default(0) double created_by,
    @JsonKey(name: 'updated_by') @Default(0) double updated_by,
    @JsonKey(name: 'reception') @Default(Reception()) Reception? reception,
    @JsonKey(name: 'level') @Default(Level()) Level? level,
    @JsonKey(name: 'pen') @Default(Pen()) Pen? pen,
  }) = _Cattle;
  const Cattle._();
  factory Cattle.fromJson(Map<String, dynamic> json) => _$CattleFromJson(json);

  bool isStatusAvailable() {
    return status == AVAILABLE;
  }

  bool isAvailableToDrafting() {
    return ear_tag.isEmpty || pen?.id.isEmpty == true;
  }

  bool isStatusSick() {
    return status == SICK;
  }

  String statusLabel() {
    if (status.isEmpty) return '-';
    return cattleStatusMap[status] ?? status;
  }

  Color statusColor() {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'unavailable':
        return Colors.purple;
      case 'sold':
      case 'booked':
        return Colors.orange;
      case 'sick':
      case 'lost':
        return Colors.deepOrange;
      case 'mutating':
        return Colors.blueGrey;
      default:
        return Colors.black;
    }
  }

  String genderLabel() {
    if (gender.isEmpty) return '-';
    return genderMap[gender] ?? gender;
  }
}
