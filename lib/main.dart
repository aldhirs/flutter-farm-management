import 'dart:async';

import 'package:farm/app/main_app.dart';
import 'package:farm/config/init.dart';
import 'package:flutter/material.dart';

void main() => runZonedGuarded(_runApp, _reportError);

Future<void> _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer().init();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

void _reportError(Object error, StackTrace stackTrace) {
  // FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
}
