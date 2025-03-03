import 'package:flutter/material.dart';
import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_landing/srs_landing.dart' as srs_landing;
import 'package:srs_common/srs_common_lib.dart';

class AuthenInitController {
  Rx<bool> language = false.obs;

  TextEditingController emailController = TextEditingController(text: "agrigo.vlg@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "AgriGo#12345");
  Rx<bool> obscurePasswordLoginText = true.obs;

  // register
  TextEditingController rgUserNameController = TextEditingController();
  TextEditingController rgEmailController = TextEditingController(text: "agrigo.vlg@gmail.com");
  TextEditingController rgPasswordController = TextEditingController(text: "AgriGo#12345");
  TextEditingController rgRePasswordController = TextEditingController(text: "AgriGo#12345");

  Rx<bool> obscurePasswordRegisterText = true.obs;
  Rx<bool> obscurePasswordReRegisterText = true.obs;

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

  coreToggleRegister() => obscurePasswordRegisterText.value = !obscurePasswordRegisterText.value;

  coreToggleReRegister() => obscurePasswordReRegisterText.value = !obscurePasswordReRegisterText.value;

  coreRegisterWithUserNameEmail() async {
    try {
      DialogUtil.showLoading();
      final authen = await AuthenService().registerWithEmailPassword(email: rgEmailController.text, password: rgPasswordController.text);
      DialogUtil.hideLoading();
      Get.toNamed(
        AllRoute.mainRoute,
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

  coreLoginWithUserNameEmail() async {
    try {
      DialogUtil.showLoading();
      final authen = await AuthenService().loginWithEmailPassword(email: emailController.text, password: passwordController.text);
      DialogUtil.hideLoading();
      Get.offAndToNamed(
        srs_landing.AllRoute.mainRoute,
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

  coreSignInWithGoogle() async {
    try {
      DialogUtil.showLoading();
      final authen = await AuthenService().signInWithGoogle();
      DialogUtil.hideLoading();
    } catch (e) {
      DialogUtil.hideLoading();
      if (e is FirebaseAuthException) {
        DialogUtil.catchException(msg: getErrorMessage(e.code));
      } else {
        DialogUtil.catchException(obj: e);
      }
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
