import 'dart:developer' as dev;

import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common_lib.dart';

import 'en_us.dart';
import 'vi_vn.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationKeys = {
    'vi_VN': viVN,
    'en_US': enUS,
  };
}

initAppTranslations() async {
  dev.log('initialize Translations', name: AuthenConfig.packageName);
  Get.appendTranslations(AppTranslation.translationKeys);
}
