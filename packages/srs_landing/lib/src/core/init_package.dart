import 'dart:developer';
import 'package:srs_landing/src/configs/all_page.dart';
import 'package:srs_landing/srs_landing.dart';
import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: LandingConfig.packageName);
  await allPage();
  await initAppTranslations();
}
