import 'package:flutter/material.dart';
import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';

class SettingInitController {
  final service = SettingService();
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
      await Future.delayed(const Duration(milliseconds: 500));
      await service.signOut();
      DialogUtil.hideLoading();
      Get.offAndToNamed(
        srs_authen.AllRoute.mainRoute,
        arguments: [{}],
      );
    } catch (e) {
      DialogUtil.hideLoading();
      if (e is FirebaseAuthException) {
        DialogUtil.catchException(msg: getErrorMessage(e.code));
      } else {
        DialogUtil.catchException(obj: e);
      }
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

  String? getErrorMessage(String? errorCode) {
    switch (errorCode) {
      case "ERROR_WRONG_PASSWORD":
      case 'wrong-password':
        return '${'kết hợp email/mật khẩu không đúng'.tr.toCapitalized()}!';

      case "ERROR_INVALID_EMAIL":
      case 'invalid-email':
        return '${"email không hợp lệ".tr.toCapitalized()}!';

      case 'invalid-credential':
        return '${"thông tin xác thực không hợp lệ".tr.toCapitalized()}!';

      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return '${"email đã được sử dụng. đi tới trang đăng nhập".tr.toCapitalized()}!';

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return '${"không tìm thấy người dùng".tr.toCapitalized()}!';

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return '${"người dùng bị vô hiệu hóa".tr.toCapitalized()}!';

      case "ERROR_TOO_MANY_REQUESTS":
        return '${"có quá nhiều yêu cầu đăng nhập vào tài khoản này".tr.toCapitalized()}!';

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return '${"lỗi máy chủ, vui lòng thử lại sau".tr.toCapitalized()}!';

      default:
        return '${'đã xảy ra lỗi dự kiến. vui lòng thử lại sau'.tr.toCapitalized()}!';
    }
  }
}
