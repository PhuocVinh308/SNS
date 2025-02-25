import 'dart:developer';

import 'package:srs_authen/srs_authen.dart' as srs_authen;

import '../config/app_config.dart';

final _mapModule = {
  'srs_authen': srs_authen.initPackage(),
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
