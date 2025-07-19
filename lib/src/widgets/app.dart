import 'package:flutter/material.dart';
import 'package:srs_common/srs_common_lib.dart';

import '../config/app_config.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: _navigatorKey,
            translationsKeys: Get.translations,
            defaultTransition: AppConfig.defaultTransition,
            locale: AppConfig.locale,
            fallbackLocale: AppConfig.fallbackLocale,
            initialRoute: AppConfig.remoteInitialRoute,
            getPages: AppConfig.getPages,
            builder: FlutterSmartDialog.init(),
            navigatorObservers: [FlutterSmartDialog.observer],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
          );
        });
  }
}
