import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/features/sales_items_form/bloc/sales_item_form_bloc.dart';
import 'package:farm/features/sales_items_form/bloc/sales_item_form_event.dart';
import 'package:farm/features/sales_items_form/bloc/sales_item_form_state.dart';
import 'package:farm/features/sales_items_form/widgets/item_widget.dart';
import 'package:farm/features/sales_items_form/widgets/search_bottom_sheet.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SalesItemFormPage extends StatefulWidget {
  const SalesItemFormPage({super.key, required this.item});

  final Sales item;

  @override
  State<StatefulWidget> createState() => _SalesItemFormPageState();
}

class _SalesItemFormPageState
    extends BasePageState<SalesItemFormPage, SalesItemFormBloc>
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
        BlocListener<SalesItemFormBloc, SalesItemFormState>(
          listenWhen: (previous, current) =>
              previous.errorSnackMessage != current.errorSnackMessage,
          listener: (context, state) async {
            if (state.errorSnackMessage.isNotEmpty) {
              ToastHelper().showToast(
                context: context,
                message: state.errorSnackMessage,
                type: ToastType.error,
              );
            }
          },
        ),
        BlocListener<SalesItemFormBloc, SalesItemFormState>(
          listenWhen: (previous, current) =>
              previous.isSuccessSave != current.isSuccessSave,
          listener: (context, state) async {
            if (state.isSuccessSave == true) {
              ToastHelper().showToast(
                context: context,
                message: 'Tambah item penjualan berhasil.',
                type: ToastType.succes,
              );
              navigator.pop(result: true);
            }
          },
        ),
      ],
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<SalesItemFormBloc, SalesItemFormState>(
      builder: (context, state) {
        return CommonScaffold(
          appBar: CommonAppBar(
            titleText: 'Tambah Item Penjualan',
            forceMaterialTransparency: false,
            actions: [
              IconButton(
                onPressed: () => _onPressFilter(),
                icon: const Icon(Icons.filter_list_alt),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _filterButton(),
          body: _listWidget(),
        );
      },
    );
  }

  Widget _listWidget() {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<SalesItemFormBloc, SalesItemFormState>(
        buildWhen: (p, c) =>
            p.items != c.items ||
            p.selectedItems != c.selectedItems ||
            p.errorMessage != c.errorMessage ||
            p.isLoadMore != c.isLoadMore,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }

          if (state.items.isEmpty) {
            return SearchBottomSheet(
              bloc: bloc,
              onDismiss: () {},
              isPage: true,
            );
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
              itemCount: state.items.length + (state.isLoadMore ? 1 : 0),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  // tampilkan indikator loading di bawah
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.items[index];
                return ItemWidget(
                  item: item,
                  selected: state.selectedItems.any((e) => e.id == item.id),
                  onTap: () {
                    bloc.add(SelectedItemChanged(cattle: item));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _filterButton() {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<SalesItemFormBloc, SalesItemFormState>(
        buildWhen: (p, c) => p.selectedItems != c.selectedItems,
        builder: (context, state) {
          final isSelected = state.selectedItems.isNotEmpty;
          return FloatingActionButton.extended(
            backgroundColor: isSelected
                ? AppColors.current.eucalyptus700
                : AppColors.current.neutral800,
            onPressed: () {
              if (isSelected) {
                bloc.add(const OnSubmit());
              } else {
                ToastHelper().showToast(
                  context: context,
                  message: 'Pilih minimal 1 sapi terlebih dahulu.',
                  type: ToastType.error,
                );
              }
            },
            label: Text(
              'Simpan',
              style: TextStyles.button2().copyWith(color: Colors.white),
            ),
            icon: const Icon(Icons.save, color: Colors.white),
          );
        },
      ),
    );
  }

  void _onPressFilter() {
    navigator.pop(result: true);
    // navigator.showBottomSheet(
    //   SearchBottomSheet(
    //     bloc: bloc,
    //     onDismiss: () {
    //       navigator.pop();
    //     },
    //   ),
    // );
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
        bloc.add(const OnClearMessage());
      },
    );
  }
}
