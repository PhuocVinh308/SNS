import 'dart:developer';

import 'package:srs_setting/src/configs/all_page.dart';
import 'package:srs_setting/srs_setting.dart';

import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: SettingConfig.packageName);
  await allPage();
  await initAppTranslations();
}
