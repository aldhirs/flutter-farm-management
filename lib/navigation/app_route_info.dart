import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:farm/domain/entities/sales/sales.dart';

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
  const factory AppRouteInfo.draftingForm({String? rfid, Cattle? cattle}) =
      DraftingForm;
  const factory AppRouteInfo.cattleCreate({
    BluetoothConnection? connection,
    String? rfid,
  }) = CattleCreate;
  const factory AppRouteInfo.sales() = SalesPage;
  const factory AppRouteInfo.salesItem({required Sales item}) = SalesItemPage;
  const factory AppRouteInfo.salesItemForm({required Sales item}) =
      SalesItemFormPage;
  const factory AppRouteInfo.salesItemPreview({
    required Sales item,
    BluetoothConnection? connection,
  }) = SalesItemPreviewPage;
  const factory AppRouteInfo.salesItemAdd({
    required Sales item,
    required bool fromManual,
    Cattle? cattle,
    String? rfid,
    BluetoothConnection? connection,
  }) = SalesItemAddPage;
  const factory AppRouteInfo.scan({
    required String route,
    Sales? sales,
    Mutation? mutation,
  }) = ScanPages;
  const factory AppRouteInfo.penDrafting() = PenDrafting;

  const factory AppRouteInfo.mutationNavBar() = MutationNavBar;
  const factory AppRouteInfo.mutationItem({
    required Mutation item,
    required bool isIn,
  }) = MutationItemPage;
  const factory AppRouteInfo.mutationItemPreview({
    required Mutation item,
    BluetoothConnection? connection,
  }) = MutationItemPreviewPage;
  // const factory AppRouteInfo.mutationItemAdd({
  //   required Mutation item,
  //   required bool fromManual,
  //   Cattle? cattle,
  //   String? rfid,
  // }) = MutationItemAddPage;
}
