import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/features/sales_items/bloc/sales_items_bloc.dart';
import 'package:farm/features/sales_items/bloc/sales_items_event.dart';
import 'package:farm/features/sales_items/bloc/sales_items_state.dart';
import 'package:farm/features/sales_items/widgets/detail_bottom_sheet.dart';
import 'package:farm/features/sales_items/widgets/item_widget.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
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
  Widget buildPage(BuildContext context) {
    return BlocBuilder<SalesItemsBloc, SalesItemsState>(
      builder: (context, state) {
        return CommonScaffold(
          appBar: CommonAppBar(
            titleText: 'Penjualan #${widget.item.customer_detail?.name}',
            forceMaterialTransparency: false,
            actions: [
              IconButton(
                onPressed: () => _onShowInfo(),
                icon: const Icon(Icons.info_outline_rounded),
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
      child: BlocBuilder<SalesItemsBloc, SalesItemsState>(
        buildWhen: (p, c) =>
            p.salesItems != c.salesItems ||
            p.errorMessage != c.errorMessage ||
            p.isLoadMore != c.isLoadMore,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
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
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index >= state.salesItems.length) {
                  // tampilkan indikator loading di bawah
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.salesItems[index];
                return ItemWidget(item: item, onTap: () {});
              },
            ),
          );
        },
      ),
    );
  }

  Widget _filterButton() {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.current.eucalyptus700,
      onPressed: () => _onShowInfo(),
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
}
