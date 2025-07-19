import 'dart:developer';

import 'package:srs_disease/src/configs/all_page.dart';
import 'package:srs_disease/srs_disease.dart';

import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: DiseaseConfig.packageName);
  await allPage();
  await initAppTranslations();
}
