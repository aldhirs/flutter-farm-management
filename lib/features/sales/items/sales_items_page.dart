import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/date_constant.dart';
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
import 'package:farm/utils/string_utils.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/common_scaffold.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/checkbox/checkbox_button.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:farm/widgets/tag/tag_status.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
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
                      borderRadius: BorderRadius.circular(20),
                      child: Assets.images.ilCowDenied.image(
                        height: Dimens.d240,
                        fit: BoxFit.cover,
                      ),
                    ),
                    description: const [
                      TextSpan(
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
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxScrolled) => [
              _buildAppBar(context, state),
              _buildSummarySection(state),
            ],
            body: _listWidget(),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1), // dari bawah
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                  ),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: state.isEditMode ? _actionButton(state) : _addButton(),
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, SalesItemsState state) {
    final sales = widget.item;
    final customer = sales.customer_detail;

    return SliverAppBar(
      expandedHeight: 230.0,
      pinned: true,
      floating: false,
      forceElevated: true,
      backgroundColor: AppColors.current.mint700,
      foregroundColor: Colors.white,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double maxHeight = 230;
          final double minHeight = kToolbarHeight;
          final double currentHeight = constraints.maxHeight;

          // Hitung persentase collapse
          final double collapsePercentage =
              (maxHeight - currentHeight) / (maxHeight - minHeight);
          final double titleOpacity = collapsePercentage.clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            title: Opacity(
              opacity: titleOpacity,
              child: Text(
                'Penjualan #${customer?.name.orEmpty()}',
                style: TextStyles.heading5().copyWith(color: Colors.white),
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF25AFCB), AppColors.current.mint500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sales Number and Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TagCategory(
                            text: sales.statusLabel(),
                            type: sales.statusType(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Customer Information
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              customer?.name ?? 'Nama tidak tersedia',
                              style: TextStyles.body2().copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (customer?.phone != null) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 26),
                          child: Text(
                            customer!.phone!,
                            style: TextStyles.paragraph2().copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sales.created_at
                                  .formatDateString(
                                    format: DateConstant.UTC,
                                    newFormat: DateConstant.DATETIME_FULL_MONTH,
                                  )
                                  .defaultValue('-'),
                              style: TextStyles.body2().copyWith(
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.key_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            child: TagCategory(
                              text: sales.sales_number,
                              type: TagCategoryType.plain,
                            ),
                            onTap: () async {
                              await ViewUtils.copyToClipboard(
                                context: context,
                                sales.sales_number,
                                message:
                                    "${sales.sales_number} berhasil disalin.",
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      actions: [
        Visibility(
          visible: widget.item.isDraft() && state.salesItems.isNotEmpty,
          child: IconButton(
            onPressed: () => bloc.add(const EditModeToggled()),
            icon: Icon(
              state.isEditMode ? Icons.close : Icons.edit,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _onShowInfo(),
          icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
        ),
      ],
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
          if (state.errorMessage.isNotEmpty) {
            return _errorWidget();
          }
          if (state.salesItems.isEmpty) {
            return _emptyWidget();
          }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: AppColors.current.mint700,
            strokeWidth: 2,
            onRefresh: () async {
              bloc.add(const Load());
            },
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              itemCount: state.salesItems.length + (state.isLoadMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: (state.isEditMode)
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CheckboxButton(
                                value: isSelected,
                                onChanged: (_) =>
                                    bloc.add(ItemSelectionToggled(item: item)),
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey("empty")),
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
    if (!widget.item.isDraft()) return const SizedBox.shrink();
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
      isButtonFullWidth: true,
      leftIconButton: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _onShowInfo() {
    navigator.showBottomSheet(
      isScrollControlled: true,
      DetailBottomSheet(item: widget.item, onDismiss: () => navigator.pop()),
    );
  }

  Widget _actionButton(SalesItemsState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, anim) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // dari bawah
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: state.selectedItems.isEmpty
          ? const SizedBox.shrink(key: ValueKey("emptyActions"))
          : Wrap(
              spacing: 16,
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
                        onDismiss: () => navigator.pop(),
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
                        onDismiss: () => navigator.pop(),
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
            ),
    );
  }

  void _addNew() async {
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        closeVisibility: true,
        title: 'Tambah Item Penjualan',
        illustration: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Assets.images.ilCowSearch.image(
            height: Dimens.d160,
            fit: BoxFit.cover,
          ),
        ),
        description: const [
          TextSpan(
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
      AddManualBottomSheet(bloc: bloc, onDismiss: () => navigator.pop()),
    );
  }

  SliverToBoxAdapter _buildSummarySection(SalesItemsState state) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.grey.shade50,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: const Column(
          children: [
            TickerView(
              type: TickerViewType.info,
              message:
                  "Anda dapat mengubah dan menghapus dengan menekan tombol pensil yang berada pada area kanan atas.",
            ),
          ],
        ),
      ),
    );
  }
}
