import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CattleManagementApp();
  }
}

class CattleManagementApp extends StatefulWidget {
  const CattleManagementApp({super.key});

  @override
  State<CattleManagementApp> createState() => _CattleManagementAppState();
}

class _CattleManagementAppState extends State<CattleManagementApp> {
  bool isLoggedIn = false;

  void _handleLoginSuccess() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void _handleLogout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cattle Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: isLoggedIn
          ? HomePage(onLogout: _handleLogout)
          : LoginPage(onLoginSuccess: _handleLoginSuccess),
    );
  }
}
