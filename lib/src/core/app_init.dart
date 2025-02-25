import 'dart:developer';

import 'package:srs_common/srs_common_lib.dart';

import '../config/app_config.dart';
import '../translations/app_translations.dart';
import 'packages_init.dart';

appInit() async {
  log('initialize Application', name: AppConfig.appName);
  await _initGetStorage();
  await _initHive();
  await initAppTranslations();
  await initPackages();
}

_initGetStorage() async {
  log('initialize GetStorage', name: AppConfig.appName);
  try {
    await GetStorage.init();
  } catch (_) {}
}

_initHive() async {
  log('initialize Hive', name: AppConfig.appName);
  var tmpDir = await getTemporaryDirectory();
  await Hive.openBox(AppConfig.storageBox, path: tmpDir.path);
}
