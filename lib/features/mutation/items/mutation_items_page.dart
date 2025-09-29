import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/features/mutation/items/bloc/mutation_items_bloc.dart';
import 'package:farm/features/mutation/items/bloc/mutation_items_event.dart';
import 'package:farm/features/mutation/items/bloc/mutation_items_state.dart';
import 'package:farm/features/mutation/items/widgets/add_manual_bottom_sheet.dart';
import 'package:farm/features/mutation/items/widgets/delete_bottom_sheet.dart';
import 'package:farm/features/mutation/items/widgets/detail_bottom_sheet.dart';
import 'package:farm/features/mutation/items/widgets/item_widget.dart';
import 'package:farm/features/mutation/items/widgets/result_cattle_bottom_sheet.dart';
import 'package:farm/features/scan/scan_page.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/checkbox/checkbox_button.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MutationItemsPage extends StatefulWidget {
  const MutationItemsPage({super.key, required this.item, required this.isIn});

  final Mutation item;
  final bool isIn;

  @override
  State<StatefulWidget> createState() => _MutationPageState();
}

class _MutationPageState
    extends BasePageState<MutationItemsPage, MutationItemsBloc>
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
        BlocListener<MutationItemsBloc, MutationItemsState>(
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
        BlocListener<MutationItemsBloc, MutationItemsState>(
          listenWhen: (previous, current) =>
              previous.isSuccessAdd != current.isSuccessAdd,
          listener: (context, state) async {
            if (state.isSuccessAdd) {
              await navigator.pop();
              await navigator.pop();
              bloc.add(const Load());
            }
          },
        ),
        BlocListener<MutationItemsBloc, MutationItemsState>(
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

              navigator.showBottomSheet(
                isScrollControlled: true,
                ResultCattleBottomSheet(
                  bloc: bloc,
                  onTap: () async {
                    bloc.add(const OnSubmitAdd());
                  },
                  onDismiss: () => navigator.pop(),
                ),
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
    return BlocBuilder<MutationItemsBloc, MutationItemsState>(
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

  SliverAppBar _buildAppBar(BuildContext context, MutationItemsState state) {
    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      floating: false,
      forceElevated: true,
      backgroundColor: AppColors.current.mint700,
      foregroundColor: Colors.white,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double maxHeight = 220;
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
                'Rincian Mutasi',
                style: TextStyles.heading5().copyWith(color: Colors.white),
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF25ADCB), AppColors.current.mint500],
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
                      DetailBottomSheet(
                        item: state.mutation,
                        onDismiss: () {},
                        isIn: widget.isIn,
                        isShowTitle: false,
                        showBottomSheet: false,
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
          visible: widget.item.isDraft() && !widget.isIn,
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
    );
  }

  Widget _listWidget() {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<MutationItemsBloc, MutationItemsState>(
        buildWhen: (p, c) =>
            p.mutationItems != c.mutationItems ||
            p.errorMessage != c.errorMessage ||
            p.isLoadMore != c.isLoadMore ||
            p.isEditMode != c.isEditMode ||
            p.selectedItems != c.selectedItems,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }

          if (state.mutationItems.isEmpty) {
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
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              itemCount:
                  state.mutationItems.length + (state.isLoadMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index >= state.mutationItems.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.mutationItems[index];
                final isSelected = state.selectedItems.contains(item);

                final content = Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: (state.isEditMode)
                          ? CheckboxButton(
                              value: isSelected,
                              onChanged: (_) =>
                                  bloc.add(ItemSelectionToggled(item: item)),
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

                return content;
              },
            ),
          );
        },
      ),
    );
  }

  Widget _addButton() {
    if (!widget.item.isDraft() || widget.isIn) {
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
      title: 'Ups!',
      description: 'Data masih kosong.',
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
      DetailBottomSheet(
        item: widget.item,
        isIn: widget.isIn,
        onDismiss: () {
          navigator.pop();
        },
        showBottomSheet: true,
      ),
    );
  }

  Widget _actionButton(MutationItemsState state) {
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
          : FloatingActionButton.extended(
              heroTag: 'deleteBtn',
              backgroundColor: AppColors.current.crimson500,
              onPressed: () async {
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
    );
  }

  void _addNew() async {
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        closeVisibility: true,
        title: 'Tambah Item Mutasi',
        illustration: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Assets.images.ilCowSearch.image(
            height: Dimens.d160,
            fit: BoxFit.cover,
          ),
        ),
        description: [
          const TextSpan(
            text:
                'Silakan pilih metode dalam penambahan item mutasi menggunakan alat pemindai atau manual dengan mencari berdasarkan sapi ear tag.',
          ),
        ],
        positiveButtonText: "Tambah dengan Alat",
        negativeButtonText: "Tambah Manual",
        onNegativeButtonPressed: () => _addManualBottomSheet(),
        onPositiveButtonPressed: () async {
          final result = await navigator.popAndPush(
            AppRouteInfo.scan(route: DEST_MUTATION_ITEM, mutation: widget.item),
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

  SliverToBoxAdapter _buildSummarySection(MutationItemsState state) {
    if (widget.isIn) {
      return const SliverToBoxAdapter(child: SizedBox(height: 16));
    }
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
