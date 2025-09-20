import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:farm/app/main_app.dart';
import 'package:farm/config/init.dart';
import 'package:farm/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:farm/firebase_options.dart';

void main() => runZonedGuarded(_runApp, _reportError);

Future<void> _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ChuckerFlutter.showNotification = false;
  // inisialisasi untuk locale Indonesia
  await initializeDateFormatting('id_ID', null);
  runApp(const MainApp());
}

void _reportError(Object error, StackTrace stackTrace) {
  FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
}
