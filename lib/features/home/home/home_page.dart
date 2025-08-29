import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/home/home/bloc/home_bloc.dart';
import 'package:farm/features/home/home/widgets/quick_action_card.dart';
import 'package:farm/features/home/home/widgets/stat_card.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';

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
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.neutral400,
      appBar: CommonAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        forceMaterialTransparency: false,
        title: Text(
          'Beranda',
          style: TextStyles.heading6().copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
