import 'dart:developer';

import 'package:srs_calendar/src/configs/all_page.dart';
import 'package:srs_calendar/srs_calendar.dart';

import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: CalendarConfig.packageName);
  await allPage();
  await initAppTranslations();
}
