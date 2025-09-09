import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/features/sales_items/bloc/sales_items_bloc.dart';
import 'package:farm/features/sales_items/bloc/sales_items_event.dart';
import 'package:farm/features/sales_items/bloc/sales_items_state.dart';
import 'package:farm/features/sales_items/widgets/detail_bottom_sheet.dart';
import 'package:farm/features/sales_items/widgets/item_widget.dart';
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
              ? _deleteButton(state)
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
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.salesItems.length + (state.isLoadMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.salesItems.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.salesItems[index];
                final isSelected = state.selectedItems.contains(item);

                return Row(
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
      title: 'Opps',
      description: bloc.state.errorMessage,
      imageAssets: Icon(
        Icons.warning_outlined,
        size: 140,
        color: AppColors.current.neutral800,
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
      imageAssets: Icon(
        Icons.list_alt_outlined,
        size: 140,
        color: AppColors.current.neutral800,
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

  Widget _deleteButton(SalesItemsState state) {
    if (state.selectedItems.isEmpty) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      backgroundColor: Colors.red,
      onPressed: () async {
        navigator.showAppDialog(
          useRootNavigator: true,
          barrierDismissible: false,
          Popup(
            title: "Konfirmasi Hapus",
            description: [
              TextSpan(
                text:
                    "Apakah anda yakin ingin menghapus ${state.selectedItems.length} item penjualan?",
              ),
            ],
            positiveButtonText: "Ya, Hapus",
            negativeButtonText: "Tidak Sekarang",
            illustration: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const Icon(Icons.delete_outline_rounded, size: 52),
            ),
            onNegativeButtonPressed: () => navigator.pop(),
            onPositiveButtonPressed: () async {
              navigator.pop();
              bloc.add(DeleteSalesItems(items: state.selectedItems));
            },
          ),
        );
      },
      label: Text(
        'Hapus (${state.selectedItems.length})',
        style: TextStyles.button2().copyWith(color: Colors.white),
      ),
      icon: const Icon(Icons.delete, color: Colors.white),
    );
  }

  void _addNew() async {
    final result = await navigator.push(
      AppRouteInfo.scan(route: DEST_SALES_ITEM, sales: widget.item),
    );
    if (result != null) {
      bloc.add(const Load());
    }
  }
}
