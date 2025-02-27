import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class AuthenInitController {
  final TextEditingController tc = TextEditingController();
  Rx<bool> language = false.obs;

  init() async {
    try {
      await _initLanguageBtn();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  _initLanguageBtn() async {
    try {
      language.value = StorageUtil().language;
      Locale locale = language.value ? const Locale('vi', 'VN') : const Locale('en', 'US');
      Get.updateLocale(locale);
    } catch (e) {
      rethrow;
    }
  }

  coreChangeLanguage(bool value) async {
    Locale locale = value ? const Locale('vi', 'VN') : const Locale('en', 'US');
    Get.updateLocale(locale);
    StorageUtil().setLanguage(value);
  }
}
