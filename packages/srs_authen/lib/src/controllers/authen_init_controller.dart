import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class AuthenInitController {
  Rx<bool> language = false.obs;

  TextEditingController emailController = TextEditingController(text: "agrigo.vlg@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "AgriGo#12345");
  Rx<bool> obscurePasswordLoginText = true.obs;

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

  coreToggleLogin() => obscurePasswordLoginText.value = !obscurePasswordLoginText.value;
}
