import 'dart:developer';

import 'package:srs_notification/src/configs/all_page.dart';
import 'package:srs_notification/srs_notification.dart';

import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: NotificationConfig.packageName);
  await allPage();
  await initAppTranslations();

  await NotificationService().initNotification();
}
