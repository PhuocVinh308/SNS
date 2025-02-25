import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:agri_go/src/core/app_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/widgets/app_widgets.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await appInit();
    runApp(const App());
  }, (error, stackTrace) {
    log(error.toString());
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
