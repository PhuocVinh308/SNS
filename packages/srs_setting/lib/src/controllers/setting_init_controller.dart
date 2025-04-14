import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common_lib.dart';

class SettingInitController {
  Rx<srs_authen.UserInfoModel> userModel = srs_authen.UserInfoModel().obs;
  Rx<bool> language = false.obs;
  init() async {
    try {
      await _initLanguageBtn();
      await initUserModel();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  initUserModel() async {
    try {
      userModel.value = CustomGlobals().userInfo;
    } catch (e) {
      rethrow;
    }
  }

  coreSignOut() async {
    try {
      DialogUtil.showLoading();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    } finally {
      DialogUtil.hideLoading();
    }
  }

  coreChangeLanguage(bool value) async {
    Locale locale = value ? const Locale('vi', 'VN') : const Locale('en', 'US');
    Get.updateLocale(locale);
    StorageUtil().setLanguage(value);
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
}
