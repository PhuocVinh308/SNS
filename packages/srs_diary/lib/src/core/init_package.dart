import 'dart:developer';

import 'package:srs_diary/src/configs/all_page.dart';
import 'package:srs_diary/srs_diary.dart';

import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: DiaryConfig.packageName);
  await allPage();
  await initAppTranslations();
}
