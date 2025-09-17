import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_bloc.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_event.dart';
import 'package:farm/features/pen_drafting/bloc/pen_drafting_state.dart';
import 'package:farm/features/pen_drafting/widgets/change_bottom_sheet.dart';
import 'package:farm/features/pen_drafting/widgets/filter_bottom_sheet.dart';
import 'package:farm/features/pen_drafting/widgets/item_widget.dart';
import 'package:farm/features/pen_drafting/widgets/detail_bottom_sheet.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class PenDraftingPage extends StatefulWidget {
  const PenDraftingPage({super.key});

  @override
  State<StatefulWidget> createState() => _PenDraftingPageState();
}

class _PenDraftingPageState
    extends BasePageState<PenDraftingPage, PenDraftingBloc>
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
    return BlocBuilder<PenDraftingBloc, PenDraftingState>(
      builder: (context, state) {
        return CommonScaffold(
          appBar: CommonAppBar(
            titleText: 'Daftar Pen Drafting',
            forceMaterialTransparency: false,
            actions: [
              IconButton(
                onPressed: () => navigator.showBottomSheet(
                  DetailBottomSheet(
                    onDismiss: () {
                      navigator.pop();
                    },
                  ),
                ),
                icon: const Icon(Icons.info_outline),
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
      child: BlocBuilder<PenDraftingBloc, PenDraftingState>(
        buildWhen: (p, c) =>
            p.items != c.items ||
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
                  onTap: () async {
                    bloc.add(const GetBarns());
                    navigator
                        .showBottomSheet(
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: true,
                          ChangeBottomSheet(
                            bloc: bloc,
                            item: item,
                            onDismiss: () {
                              navigator.pop();
                            },
                          ),
                        )
                        .then((_) {
                          bloc.add(
                            const ResetBottomsheet(),
                          ); // reset saat bottom sheet ditutup
                        });
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
        bloc.add(const Load());
      },
    );
  }
}
