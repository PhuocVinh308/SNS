import 'dart:developer';

import 'package:srs_common/srs_common_lib.dart';

import '../config/app_config.dart';
import 'en_us.dart';
import 'vi_vn.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationKeys = {
    'vi_VN': viVN,
    'en_US': enUS,
  };
}

initAppTranslations() async {
  log('initialize Translations', name: AppConfig.appName);
  Get.appendTranslations(AppTranslation.translationKeys);
}
