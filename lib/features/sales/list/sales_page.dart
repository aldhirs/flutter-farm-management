import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/sales/list/bloc/sales_bloc.dart';
import 'package:farm/features/sales/list/bloc/sales_event.dart';
import 'package:farm/features/sales/list/bloc/sales_state.dart';
import 'package:farm/features/sales/list/widgets/filter_bottom_sheet.dart';
import 'package:farm/features/sales/list/widgets/item_widget.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<StatefulWidget> createState() => _SalesPageState();
}

class _SalesPageState extends BasePageState<SalesPage, SalesBloc>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());

    // Listen scroll untuk load more
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // kurang dari 200px dari bawah, load more
        if (!bloc.state.isLoadMore && bloc.state.hasMore) {
          bloc.add(const LoadMoreSales());
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
    return BlocBuilder<SalesBloc, SalesState>(
      builder: (context, state) {
        return CommonScaffold(
          backgroundColor: AppColors.current.neutral400,
          appBar: CommonAppBar(
            titleText: 'Daftar Penjualan',
            forceMaterialTransparency: false,
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
      child: BlocBuilder<SalesBloc, SalesState>(
        buildWhen: (p, c) =>
            p.sales != c.sales ||
            p.errorMessage != c.errorMessage ||
            p.isLoadMore != c.isLoadMore,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }

          if (state.sales.isEmpty) {
            return _emptyWidget();
          }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: AppColors.current.mint700,
            strokeWidth: 2.0,
            onRefresh: () async {
              bloc.add(const LoadSales(withFilter: true));
            },
            // Pull from top to show refresh indicator.
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.sales.length + (state.isLoadMore ? 1 : 0),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index >= state.sales.length) {
                  // tampilkan indikator loading di bawah
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.sales[index];
                return ItemWidget(
                  sale: item,
                  onTap: () =>
                      navigator.push(AppRouteInfo.salesItem(item: item)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _emptyWidget() {
    return EmptyState(
      title: 'Data masih kosong',
      description: 'Data penjualan masih kosong.',
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(20), // adjust radius
        child: Assets.images.ilNotFound.image(
          height: Dimens.d240,
          fit: BoxFit.contain,
        ),
      ),
      isEnabledPositifButton: false,
    );
  }

  Widget _filterButton() {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.current.eucalyptus700,
      onPressed: () => navigator.showBottomSheet(
        FilterBottomSheet(
          bloc: bloc,
          onDismiss: () {
            navigator.pop();
          },
        ),
      ),
      label: Text(
        'Filter',
        style: TextStyles.button2().copyWith(color: Colors.white),
      ),
      icon: const Icon(Icons.filter_list_alt, color: Colors.white),
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
        bloc.add(const LoadSales());
      },
    );
  }
}
