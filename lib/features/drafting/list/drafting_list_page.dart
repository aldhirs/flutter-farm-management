import 'package:auto_route/auto_route.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/drafting/list/bloc/drafting_list_bloc.dart';
import 'package:farm/features/drafting/list/bloc/drafting_list_event.dart';
import 'package:farm/features/drafting/list/bloc/drafting_list_state.dart';
import 'package:farm/features/drafting/list/widgets/item_widget.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DraftingListPage extends StatefulWidget {
  const DraftingListPage({super.key});

  @override
  State<StatefulWidget> createState() => _DraftingListPageState();
}

class _DraftingListPageState
    extends BasePageState<DraftingListPage, DraftingListBloc> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());

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
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.neutral400,
      appBar: CommonAppBar(
        titleText: 'Sapi Belum Didrafting',
        forceMaterialTransparency: false,
      ),
      body: BlocBuilder<DraftingListBloc, DraftingListState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            return _errorWidget(state);
          }
          if (state.items.isEmpty) {
            return _emptyWidget();
          }
          return Column(
            children: [
              _countBar(state),
              Expanded(child: _list(state)),
            ],
          );
        },
      ),
    );
  }

  /// Menyebutkan jumlah seluruhnya, bukan jumlah yang sedang terlihat.
  ///
  /// Angka inilah yang tadi ditekan orang di beranda; menampilkan panjang
  /// daftar yang dimuat bertahap akan membuatnya tidak cocok dengan kartu yang
  /// membawanya ke sini.
  Widget _countBar(DraftingListState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.d16,
        Dimens.d12,
        Dimens.d16,
        Dimens.d4,
      ),
      child: Row(
        children: [
          Text(
            '${state.total}',
            style: TextStyles.heading5().copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.current.mint700,
            ),
          ),
          const SizedBox(width: Dimens.d6),
          Text(
            'ekor menunggu didrafting',
            style: TextStyles.label2().copyWith(
              color: AppColors.current.neutral800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _list(DraftingListState state) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: AppColors.current.mint700,
      onRefresh: () async => bloc.add(const Refreshed()),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: Dimens.d24),
        itemCount: state.items.length + (state.isLoadMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.d16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final cattle = state.items[index];
          return ItemWidget(
            cattle: cattle,
            onTap: () => _onCattlePressed(cattle),
          );
        },
      ),
    );
  }

  /// Membuka formulir drafting untuk ternak yang ditekan.
  ///
  /// Ternaknya diteruskan utuh, jadi formulir tidak perlu memanggil server lagi
  /// hanya untuk mendapatkan yang sudah ada di tangan. Setelah formulir
  /// ditutup, daftar dimuat ulang: ternak yang baru saja ditempatkan ke pen
  /// tidak lagi termasuk "belum didrafting", dan membiarkannya tetap di daftar
  /// akan mengundang orang mengerjakannya dua kali.
  Future<void> _onCattlePressed(Cattle cattle) async {
    await navigator.push(AppRouteInfo.draftingForm(cattle: cattle));
    bloc.add(const Refreshed());
  }

  Widget _emptyWidget() {
    return EmptyState(
      title: 'Semua sapi sudah didrafting',
      description:
          'Tidak ada sapi yang menunggu didrafting di feedlot ini. '
          'Sapi baru akan muncul di sini setelah berkas LNC diunggah.',
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.d20),
        child: Assets.images.ilCowSuccess.image(
          height: Dimens.d240,
          fit: BoxFit.contain,
        ),
      ),
      isEnabledPositifButton: false,
    );
  }

  Widget _errorWidget(DraftingListState state) {
    return EmptyState(
      title: 'Ups!',
      description: state.errorMessage,
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.d20),
        child: Assets.images.ilNotFound.image(
          height: Dimens.d240,
          fit: BoxFit.contain,
        ),
      ),
      isEnabledPositifButton: true,
      buttonText: 'Coba Lagi',
      isButtonFullWidth: true,
      onPressed: () => bloc.add(const Refreshed()),
    );
  }
}
