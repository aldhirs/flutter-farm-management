import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:farm/app/bloc/app_bloc.dart';
import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/app/bloc/app_state.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/home/home/bloc/home_bloc.dart';
import 'package:farm/features/home/home/bloc/home_state.dart';
import 'package:farm/features/home/home/widgets/cattle_search_bottom_sheet.dart';
import 'package:farm/features/home/home/widgets/quick_action_card.dart';
import 'package:farm/features/scan/scan_page.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/date_time_utils.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_bottomsheet.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage, HomeBloc>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeStats;
  late final Animation<Offset> _slideStats;
  late final Animation<double> _fadeShortcutTitle;
  late final Animation<Offset> _slideShortcutTitle;
  late final Animation<double> _fadeQuickActions;
  late final Animation<Offset> _slideQuickActions;
  String? selectedValue = "Option 1";

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.showProjects != current.showProjects,
          listener: (context, state) async {
            if (!state.showProjects) {
              return;
            }
            _showFeedlot(state);
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) async {
            if (state.cattle != null) {
              navigator.popAndPush(
                AppRouteInfo.cattleSearch(cattle: state.cattle),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (BuildContext context) => appBloc),
      ],
      child: CommonScaffold(
        backgroundColor: AppColors.current.neutral400,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              _fadeSlide(
                fade: _fadeStats,
                slide: _slideStats,
                child: Text(
                  'Selamat Datang, ${appBloc.state.userData?.full_name}',
                  style: TextStyles.heading5(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 24),
              _fadeSlide(
                fade: _fadeStats,
                slide: _slideStats,
                child: _summaryWidget(),
              ),
              const SizedBox(height: 16),
              _fadeSlide(
                fade: _fadeShortcutTitle,
                slide: _slideShortcutTitle,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Discover", style: TextStyles.body2()),
                    Text(
                      "Terakhir diperbarui: ${DateTime.now().toString().formatDateString(format: DateConstant.UTC, newFormat: DateConstant.DATETIME_FULL_MONTH)}",
                      style: TextStyles.label3(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              _fadeSlide(
                fade: _fadeStats,
                slide: _slideStats,
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.45,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    _buildSummaryCard(
                      "Draf Sapi",
                      "120",
                      LucideIcons.pawPrint,
                      const [Colors.white, Color(0xFFFFE0F7)],
                    ),
                    _buildSummaryCard(
                      "Draf Penjualan",
                      "3",
                      LucideIcons.shoppingCart,
                      const [Colors.white, Color(0xFFFAD0C4)],
                    ),
                    _buildSummaryCard(
                      "Mutasi Masuk",
                      "2",
                      LucideIcons.arrowDown,
                      const [Colors.white, Color(0xFFFFC3A0)],
                    ),
                    _buildSummaryCard(
                      "Mutasi Keluar",
                      "1",
                      LucideIcons.arrowUp,
                      const [Colors.white, Color(0xFFA6C1EE)],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _fadeSlide(
                fade: _fadeShortcutTitle,
                slide: _slideShortcutTitle,
                child: Text("Menu", style: TextStyles.body2()),
              ),

              const SizedBox(height: 10),
              // 🔹 Step 3 — Quick actions
              _fadeSlide(
                fade: _fadeQuickActions,
                slide: _slideQuickActions,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    QuickActionCard(
                      icon: LucideIcons.shuffle,
                      label: "Mutasi",
                      onTap: () =>
                          _onMenuClicked(const AppRouteInfo.mutationNavBar()),
                    ),
                    QuickActionCard(
                      icon: LucideIcons.dollarSign,
                      label: "Penjualan",
                      onTap: () => _onMenuClicked(const AppRouteInfo.sales()),
                    ),
                    QuickActionCard(
                      icon: LucideIcons.layers,
                      label: "Pen Drafting",
                      onTap: () =>
                          _onMenuClicked(const AppRouteInfo.penDrafting()),
                    ),
                    QuickActionCard(
                      icon: LucideIcons.alignEndVertical,
                      label: "Drafting",
                      onTap: () => _onMenuClicked(
                        const AppRouteInfo.scan(route: DEST_DRAFTING_DETAIL),
                      ),
                    ),
                    QuickActionCard(
                      icon: LucideIcons.plus,
                      label: "Tambah Sapi",
                      onTap: () =>
                          _onMenuClicked(const AppRouteInfo.cattleCreate()),
                    ),
                    QuickActionCard(
                      icon: LucideIcons.search,
                      label: "Cari Sapi",
                      onTap: _onSearchCattleClicked,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 62),
            ],
          ),
        ),
      ),
    );
  }

  void _onShowFeedlotAlert() {
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        title: 'Feedlot belum diisi',
        illustration: ClipRRect(
          borderRadius: BorderRadius.circular(20), // adjust radius
          child: Assets.images.ilCowFeedlot.image(
            height: Dimens.d140,
            fit: BoxFit.cover,
          ),
        ),
        description: [
          const TextSpan(
            text:
                "Silakan untuk memilih feedlot terlebih dahulu untuk melanjutkan aktivitas.",
          ),
        ],
        positiveButtonText: "Pilih Feedlot",
        onPositiveButtonPressed: () async {
          navigator.pop();
          appBloc.add(const ShowProjects());
        },
      ),
    );
  }

  void _onMenuClicked(AppRouteInfo route) async {
    if (appBloc.state.selectedProject == null) {
      _onShowFeedlotAlert();
    } else {
      await navigator.push(route);
      // await navigator.pushRoute(DashboardRoute());
    }
  }

  void _showFeedlot(AppState state) {
    navigator.showBottomSheet(
      DropdownViewBottomsheet(
        title: 'Pilih Feedlot',
        searchHint: '',
        items: ValueNotifier<List<DropdownCheckboxModel>>(
          state.projects
              .map(
                (item) => DropdownCheckboxModel(
                  text: item.name,
                  selected: item.id == state.selectedProject?.id,
                ),
              )
              .toList(),
        ),
        navigator: navigator,
        onDismiss: () {},
        onChoose: (value) {
          final selected = value.where((item) => item.selected).first;
          final selectedProject = state.projects
              .where((item) => item.name == selected.text)
              .first;
          appBloc.add(SelectedProject(project: selectedProject));
        },

        dropdownType: DropdownTypeEnum.single,
        dismissible: true,
      ),
      onDismiss: () {
        appBloc.add(const DismissProjects());
      },
    );
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Staggered intervals for step-by-step appearance
    final statsCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.45, curve: Curves.easeOut),
    );
    final titleCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.20, 0.70, curve: Curves.easeOut),
    );
    final quickActionsCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1.00, curve: Curves.easeOut),
    );

    _fadeStats = Tween(begin: 0.0, end: 1.0).animate(statsCurve);
    _slideStats = Tween(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(statsCurve);

    _fadeShortcutTitle = Tween(begin: 0.0, end: 1.0).animate(titleCurve);
    _slideShortcutTitle = Tween(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(titleCurve);

    _fadeQuickActions = Tween(begin: 0.0, end: 1.0).animate(quickActionsCurve);
    _slideQuickActions = Tween(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(quickActionsCurve);

    // Kick off the animation on first build
    _controller.forward();
  }

  Widget _fadeSlide({
    required Animation<double> fade,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  Widget _summaryWidget() {
    return BlocProvider.value(
      value: appBloc,
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (p, c) => p.selectedProject != c.selectedProject,
        builder: (context, state) {
          return InkWell(
            onTap: () {
              appBloc.add(const GetProjects());
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF25ADCB), AppColors.current.mint500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(
                      LucideIcons.warehouse,
                      size: 32,
                      color: AppColors.current.mint700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (appBloc.state.selectedProject?.name).defaultValue(
                          'Belum diset',
                        ),
                        style: TextStyles.heading4().copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Tekan untuk mengubah feedlot",
                        style: TextStyles.label2().copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    List<Color> colors,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: AppColors.current.mint700),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          Text(
            title,
            style: TextStyles.body3().copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  void _onSearchCattleClicked() async {
    if (appBloc.state.selectedProject == null) {
      _onShowFeedlotAlert();
      return;
    }
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        closeVisibility: true,
        title: 'Cari Sapi',
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
                'Silakan pilih metode dalam pencarian sapi menggunakan alat pemindai atau manual berdasarakan ear tag.',
          ),
        ],
        positiveButtonText: "Cari dengan Alat",
        negativeButtonText: "Cari Manual",
        onNegativeButtonPressed: _searchCattleManualBottomSheet,
        onPositiveButtonPressed: () async {
          await navigator.popAndPush(
            const AppRouteInfo.scan(route: DEST_CATTLE_DETAIL),
          );
        },
      ),
    );
  }

  void _searchCattleManualBottomSheet() async {
    await navigator.pop();
    await navigator.showBottomSheet(
      isScrollControlled: true,
      CattleSearchBottomSheet(bloc: bloc, onDismiss: () => navigator.pop()),
    );
  }
}
