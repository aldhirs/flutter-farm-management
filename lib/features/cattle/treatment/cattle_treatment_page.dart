import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/features/cattle/treatment/bloc/cattle_treatment_bloc.dart';
import 'package:farm/features/cattle/treatment/bloc/cattle_treatment_event.dart';
import 'package:farm/features/cattle/treatment/bloc/cattle_treatment_state.dart';
import 'package:farm/features/cattle/treatment/widgets/item_widget.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CattleTreatmentPage extends StatefulWidget {
  const CattleTreatmentPage({super.key, required this.cattle});

  final Cattle cattle;

  @override
  State<StatefulWidget> createState() => _CattleTreatmentPageState();
}

class _CattleTreatmentPageState
    extends BasePageState<CattleTreatmentPage, CattleTreatmentBloc>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    bloc.add(Initiated(cattle: widget.cattle));

    // Listen scroll untuk load more
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // kurang dari 200px dari bawah, load more
        if (!bloc.state.isLoadMore && bloc.state.hasMore) {
          bloc.add(const LoadMoreCattleTreatment());
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
    return BlocBuilder<CattleTreatmentBloc, CattleTreatmentState>(
      builder: (context, state) {
        return CommonScaffold(
          backgroundColor: AppColors.current.neutral400,
          appBar: CommonAppBar(
            titleText: 'Daftar Perawatan Sapi',
            forceMaterialTransparency: false,
          ),
          body: _listWidget(),
        );
      },
    );
  }

  Widget _listWidget() {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<CattleTreatmentBloc, CattleTreatmentState>(
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
              bloc.add(const LoadCattleTreatment());
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
                return ItemWidget(item: item, onTap: () => {});
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
        bloc.add(const LoadCattleTreatment());
      },
    );
  }
}
