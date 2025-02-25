import 'dart:developer';

import 'package:srs_authen/src/configs/all_page.dart';
import 'package:srs_authen/srs_authen.dart';
import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: AuthenConfig.packageName);
  await allPage();
  await initAppTranslations();
}
