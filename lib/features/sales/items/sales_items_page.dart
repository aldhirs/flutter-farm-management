import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/sales/items/bloc/sales_items_bloc.dart';
import 'package:farm/features/sales/items/bloc/sales_items_event.dart';
import 'package:farm/features/sales/items/bloc/sales_items_state.dart';
import 'package:farm/features/sales/items/widgets/add_manual_bottom_sheet.dart';
import 'package:farm/features/sales/items/widgets/detail_bottom_sheet.dart';
import 'package:farm/features/sales/items/widgets/item_widget.dart';
import 'package:farm/features/sales/items/widgets/delete_bottom_sheet.dart';
import 'package:farm/features/sales/items/widgets/move_bottom_sheet.dart';
import 'package:farm/features/scan/scan_page.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/checkbox/checkbox_button.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SalesItemsPage extends StatefulWidget {
  const SalesItemsPage({super.key, required this.item});

  final Sales item;

  @override
  State<StatefulWidget> createState() => _SalesPageState();
}

class _SalesPageState extends BasePageState<SalesItemsPage, SalesItemsBloc>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    bloc.add(Initiated(item: widget.item));

    // Listen scroll untuk load more
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // kurang dari 200px dari bawah, load more
        if (!bloc.state.isLoadMore && bloc.state.hasMore) {
          bloc.add(const LoadMore());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SalesItemsBloc, SalesItemsState>(
          listenWhen: (previous, current) =>
              previous.successMessage != current.successMessage,
          listener: (context, state) async {
            if (state.successMessage.isNotEmpty) {
              ToastHelper().showToast(
                context: context,
                message: state.successMessage,
                type: ToastType.succes,
              );
            }
          },
        ),
        BlocListener<SalesItemsBloc, SalesItemsState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) async {
            if (state.cattle != null) {
              if (state.cattle?.isStatusAvailable() == false) {
                navigator.showAppDialog(
                  useRootNavigator: true,
                  barrierDismissible: false,
                  Popup(
                    title: 'Tidak dapat dilanjutkan',
                    illustration: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // adjust radius
                      child: Assets.images.ilCowDenied.image(
                        height: Dimens.d240,
                        fit: BoxFit.cover,
                      ),
                    ),
                    description: [
                      const TextSpan(
                        text:
                            'Data sapi ini tidak tersedia atau sudah dipesan.',
                      ),
                    ],
                    positiveButtonText: "Mengerti",
                    onPositiveButtonPressed: () async {
                      navigator.pop();
                    },
                  ),
                );
                return;
              }

              ToastHelper().showToast(
                context: context,
                message:
                    "Data sapi ${state.cattle?.ear_tag.defaultValue('-')} berhasil ditemukan",
                type: ToastType.succes,
              );
              final result = await navigator.popAndPush(
                AppRouteInfo.salesItemAdd(
                  item: state.sales,
                  cattle: state.cattle,
                  fromManual: true,
                ),
              );
              if (result != null) {
                bloc.add(const Load());
              }
            }
          },
        ),
      ],
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<SalesItemsBloc, SalesItemsState>(
      builder: (context, state) {
        return CommonScaffold(
          appBar: CommonAppBar(
            titleText: 'Penjualan #${widget.item.customer_detail?.name}',
            forceMaterialTransparency: false,
            actions: [
              Visibility(
                visible: widget.item.isDraft(),
                child: IconButton(
                  onPressed: () => bloc.add(const EditModeToggled()),
                  icon: Icon(state.isEditMode ? Icons.close : Icons.edit),
                ),
              ),
              IconButton(
                onPressed: () => _onShowInfo(),
                icon: const Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state.isEditMode
              ? _actionButton(state)
              : _addButton(),
          body: _listWidget(),
        );
      },
    );
  }

  Widget _listWidget() {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<SalesItemsBloc, SalesItemsState>(
        buildWhen: (p, c) =>
            p.salesItems != c.salesItems ||
            p.errorMessage != c.errorMessage ||
            p.isLoadMore != c.isLoadMore ||
            p.isEditMode != c.isEditMode ||
            p.selectedItems != c.selectedItems,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }

          if (state.salesItems.isEmpty) {
            return _emptyWidget();
          }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: AppColors.current.mint700,
            strokeWidth: 2.0,
            onRefresh: () async {
              bloc.add(const Load());
            },
            // Pull from top to show refresh indicator.
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.salesItems.length + (state.isLoadMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index >= state.salesItems.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.salesItems[index];
                final isSelected = state.selectedItems.contains(item);

                final content = Row(
                  children: [
                    if (state.isEditMode)
                      CheckboxButton(
                        value: isSelected,
                        onChanged: (_) =>
                            bloc.add(ItemSelectionToggled(item: item)),
                      ),
                    Expanded(
                      child: ItemWidget(
                        item: item,
                        onTap: state.isEditMode
                            ? () => bloc.add(ItemSelectionToggled(item: item))
                            : () {},
                      ),
                    ),
                  ],
                );

                return index == 0
                    ? Column(children: [const SizedBox(height: 8), content])
                    : content;
              },
            ),
          );
        },
      ),
    );
  }

  Widget _addButton() {
    if (!widget.item.isDraft()) {
      return const SizedBox.shrink();
    }
    return FloatingActionButton.extended(
      heroTag: 'addBtn',
      backgroundColor: AppColors.current.eucalyptus700,
      onPressed: () => _addNew(),
      label: Text(
        'Tambah Data',
        style: TextStyles.button2().copyWith(color: Colors.white),
      ),
      icon: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _errorWidget() {
    return EmptyState(
      title: 'Ups!',
      description: bloc.state.errorMessage,
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(20), // adjust radius
        child: Assets.images.ilNotFound.image(
          height: Dimens.d240,
          fit: BoxFit.contain,
        ),
      ),
      isEnabledPositifButton: true,
      buttonText: 'Muat Ulang',
      isButtonFullWidth: true,
      leftIconButton: const Icon(Icons.refresh, color: Colors.white),
      onPressed: () async {
        bloc.add(const Load());
      },
    );
  }

  Widget _emptyWidget() {
    return EmptyState(
      title: 'Data masih kosong',
      description:
          'Data sapi masih kosong, silakan tambah sapi baru dalam penjualan ini.',
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(20), // adjust radius
        child: Assets.images.ilNotFound.image(
          height: Dimens.d240,
          fit: BoxFit.contain,
        ),
      ),
      isEnabledPositifButton: true,
      buttonText: 'Tambah Data',
      isButtonFullWidth: true,
      leftIconButton: const Icon(Icons.add, color: Colors.white),
      onPressed: () => _addNew(),
    );
  }

  void _onShowInfo() {
    navigator.showBottomSheet(
      DetailBottomSheet(
        item: widget.item,
        onDismiss: () {
          navigator.pop();
        },
      ),
    );
  }

  Widget _actionButton(SalesItemsState state) {
    if (state.selectedItems.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Aligns buttons to the right
      children: [
        FloatingActionButton.extended(
          heroTag: 'moveBtn',
          backgroundColor: AppColors.current.mint700,
          onPressed: () async {
            if (state.salesList.isEmpty) {
              bloc.add(const SalesList());
            }
            navigator.showBottomSheet(
              MoveBottomSheet(
                bloc: bloc,
                onDismiss: () {
                  navigator.pop();
                },
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            );
          },
          label: Text(
            'Pindah Penjualan (${state.selectedItems.length})',
            style: TextStyles.button2().copyWith(color: Colors.white),
          ),
          icon: const Icon(Icons.move_up, color: Colors.white),
        ),
        const SizedBox(width: 16),
        FloatingActionButton.extended(
          heroTag: 'deleteBtn',
          backgroundColor: AppColors.current.crimson500,
          onPressed: () async {
            if (state.barns.isEmpty) {
              bloc.add(const GetBarns());
            }
            navigator.showBottomSheet(
              DeleteBottomSheet(
                bloc: bloc,
                onDismiss: () {
                  navigator.pop();
                },
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            );
          },
          label: Text(
            'Hapus (${state.selectedItems.length})',
            style: TextStyles.button2().copyWith(color: Colors.white),
          ),
          icon: const Icon(Icons.delete, color: Colors.white),
        ),
      ],
    );
  }

  void _addNew() async {
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        closeVisibility: true,
        title: 'Tambah Item Penjualan',
        description: [
          const TextSpan(
            text:
                'Silakan pilih metode dalam penambahan item penjualan menggunakan alat pemindai atau manual dengan mencari berdasarkan sapi ear tag.',
          ),
        ],
        positiveButtonText: "Tambah dengan Alat",
        negativeButtonText: "Tambah Manual",
        onNegativeButtonPressed: () => _addManualBottomSheet(),
        onPositiveButtonPressed: () async {
          final result = await navigator.popAndPush(
            AppRouteInfo.scan(route: DEST_SALES_ITEM, sales: widget.item),
          );
          if (result == null) {
            bloc.add(const Load());
          }
        },
      ),
    );
  }

  void _addManualBottomSheet() async {
    await navigator.pop();
    await navigator.showBottomSheet(
      isScrollControlled: true,
      AddManualBottomSheet(
        bloc: bloc,
        onDismiss: () {
          navigator.pop();
        },
      ),
    );
  }
}
