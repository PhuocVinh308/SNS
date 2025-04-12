import 'dart:developer';

import 'package:srs_forum/src/configs/all_page.dart';
import 'package:srs_forum/srs_forum.dart';

import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: ForumConfig.packageName);
  await allPage();
  await initAppTranslations();
}
