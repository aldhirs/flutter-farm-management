import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_route_info.freezed.dart';

/// page
@freezed
abstract class AppRouteInfo with _$AppRouteInfo {
  // auth
  const factory AppRouteInfo.welcome() = Welcome;

  const factory AppRouteInfo.login({String? messageChangePassword}) = Login;
  const factory AppRouteInfo.home() = Home;
  const factory AppRouteInfo.account() = Account;
  const factory AppRouteInfo.draftingScan() = DraftingScan;
  const factory AppRouteInfo.draftingDetail({BluetoothConnection? connection}) =
      DraftingDetail;
  const factory AppRouteInfo.draftingForm({required String rfid}) =
      DraftingForm;
}
