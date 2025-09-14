import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/mutation/list/bloc/mutation_list_bloc.dart';
import 'package:farm/features/mutation/list/bloc/mutation_list_event.dart';
import 'package:farm/features/mutation/list/bloc/mutation_list_state.dart';
import 'package:farm/features/mutation/list/widgets/filter_bottom_sheet.dart';
import 'package:farm/features/mutation/list/widgets/item_widget.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MutationListPage extends StatefulWidget {
  const MutationListPage({super.key, required this.isIn});

  final bool isIn;

  @override
  State<StatefulWidget> createState() => _MutationListPageState();
}

class _MutationListPageState
    extends BasePageState<MutationListPage, MutationListBloc>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    bloc.add(Initiated(isIn: widget.isIn));

    // Listen scroll untuk load more
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // kurang dari 200px dari bawah, load more
        if (!bloc.state.isLoadMore && bloc.state.hasMore) {
          bloc.add(const LoadMoreMutationList());
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
    return BlocBuilder<MutationListBloc, MutationListState>(
      builder: (context, state) {
        return CommonScaffold(
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
      child: BlocBuilder<MutationListBloc, MutationListState>(
        buildWhen: (p, c) =>
            p.items != c.items ||
            p.errorMessage != c.errorMessage ||
            p.isLoadMore != c.isLoadMore,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }

          if (state.items.isEmpty) {
            return _emptyWidget();
          }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: AppColors.current.mint700,
            strokeWidth: 2.0,
            onRefresh: () async {
              bloc.add(const LoadMutationList());
            },
            // Pull from top to show refresh indicator.
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
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
                  isIn: widget.isIn,
                  item: item,
                  onTap: () => navigator.push(
                    AppRouteInfo.mutationItem(item: item, isIn: widget.isIn),
                  ),
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
      title: 'Ups!',
      description: 'Data tidak ditemukan.',
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
      heroTag: "filter-${widget.isIn ? 'in' : 'out'}",
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
        bloc.add(const LoadMutationList());
      },
    );
  }
}
