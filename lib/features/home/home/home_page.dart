import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:farm/app/bloc/app_bloc.dart';
import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/app/bloc/app_state.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/home/home/bloc/home_bloc.dart';
import 'package:farm/features/home/home/widgets/quick_action_card.dart';
import 'package:farm/features/home/home/widgets/stat_card.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_bottomsheet.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        appBar: CommonAppBar(
          automaticallyImplyLeading: false,
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          forceMaterialTransparency: false,
          title: BlocProvider.value(
            value: appBloc,
            child: BlocBuilder<AppBloc, AppState>(
              buildWhen: (p, c) => p.selectedProject != c.selectedProject,
              builder: (context, state) {
                final selectedProject = state.selectedProject?.name;
                return InkWell(
                  onTap: () {
                    appBloc.add(const GetProjects());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.feed_outlined),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          selectedProject
                              .defaultValue('Belum dipilih')
                              .orEmpty(),
                          style: TextStyles.body1().copyWith(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fadeSlide(
                fade: _fadeStats,
                slide: _slideStats,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang, Anda berada pada:',
                      style: TextStyles.heading6(),
                    ),
                    const SizedBox(height: 8),
                    BlocProvider.value(
                      value: appBloc,
                      child: BlocBuilder<AppBloc, AppState>(
                        buildWhen: (p, c) =>
                            p.selectedProject != c.selectedProject,
                        builder: (context, state) {
                          final selectedProject = state.selectedProject?.name;
                          return InkWell(
                            onTap: () {
                              appBloc.add(const GetProjects());
                            },
                            child: TagCategory(
                              text: selectedProject
                                  .defaultValue('Belum dipilih')
                                  .orEmpty(),
                              type: selectedProject?.isNotEmpty == true
                                  ? TagCategoryType.mintSolid
                                  : TagCategoryType.crismon,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Klik untuk mengganti Feedlot',
                      style: TextStyles.body3(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _fadeSlide(
                fade: _fadeStats,
                slide: _slideStats,
                child: const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    StatCard(
                      title: "Drafting Total",
                      count: "120",
                      color: Colors.green,
                      icon: Icons.pets,
                    ),
                    StatCard(
                      title: "Rooms",
                      count: "12",
                      color: Colors.blue,
                      icon: Icons.meeting_room,
                    ),
                    StatCard(
                      title: "Available",
                      count: "5",
                      color: Colors.orange,
                      icon: Icons.check_circle,
                    ),
                    StatCard(
                      title: "Sales",
                      count: "30",
                      color: Colors.red,
                      icon: Icons.shopping_cart,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _fadeSlide(
                fade: _fadeShortcutTitle,
                slide: _slideShortcutTitle,
                child: Text("Jalan Pintas", style: TextStyles.heading6()),
              ),

              const SizedBox(height: 10),
              // 🔹 Step 3 — Quick actions
              _fadeSlide(
                fade: _fadeQuickActions,
                slide: _slideQuickActions,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.list_alt,
                        label: "Drafting",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.sell,
                        label: "Sales",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.barcode_reader,
                        label: "Gun Connect",
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
}
