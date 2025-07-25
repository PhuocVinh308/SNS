import 'dart:developer';

import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_calendar/srs_calendar.dart' as srs_calendar;
import 'package:srs_common/srs_common.dart' as srs_common;
import 'package:srs_diary/srs_diary.dart' as srs_diary;
import 'package:srs_disease/srs_disease.dart' as srs_disease;
import 'package:srs_forum/srs_forum.dart' as srs_forum;
import 'package:srs_landing/srs_landing.dart' as srs_landing;
import 'package:srs_notification/srs_notification.dart' as srs_notification;
import 'package:srs_setting/srs_setting.dart' as srs_setting;
import 'package:srs_transaction/srs_transaction.dart' as srs_transaction;

import '../config/app_config.dart';

final _mapModule = {
  'srs_authen': srs_authen.initPackage(),
  'srs_landing': srs_landing.initPackage(),
  'srs_forum': srs_forum.initPackage(),
  'srs_common': srs_common.initPackage(),
  'srs_notification': srs_notification.initPackage(),
  'srs_setting': srs_setting.initPackage(),
  'srs_calendar': srs_calendar.initPackage(),
  'srs_diary': srs_diary.initPackage(),
  'srs_disease': srs_disease.initPackage(),
  'srs_transaction': srs_transaction.initPackage(),
};

//
// initHive() async {
//   log('initialize Hive', name: AppConfig.appName);
//   var tmpDir = await getTemporaryDirectory();
//   await Hive.openBox(AppConfig.storageBox, path: tmpDir.path);
// }
//
// initHives() async {
//   log('initialize Hives', name: AppConfig.appName);
//   var tmpDir = await getTemporaryDirectory();
//   for (var key in _mapModule.keys) {
//     await Hive.openBox(key, path: tmpDir.path);
//   }
// }

initPackages() async {
  log('initialize Packages', name: AppConfig.appName);
  _mapModule.forEach((k, v) async {
    try {
      await v.call();
    } catch (_) {}
  });
}
