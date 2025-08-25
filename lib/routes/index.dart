
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:go_router/go_router.dart';
import 'package:farm/features/drafting/drafting_scan_page.dart';
import 'package:farm/features/home/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        }
      ),
      GoRoute(
        path: '/drafting-scan',
        name: 'drafting',
        builder: (BuildContext context, GoRouterState state) {
          final connection = state.extra as BluetoothConnection;
          return DraftingScanPage(connection: connection);
        },
      ),
    ],
  );
} 