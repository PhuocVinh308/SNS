import 'dart:developer';

import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common_lib.dart';

import 'authen_init_controller.dart';

class AuthenController extends GetxController with AuthenInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: AuthenConfig.packageName);
    await init();
    super.onInit();
  }

  funChangeLanguage(bool value) => coreChangeLanguage(value);

  funToggleLogin() => coreToggleLogin();

  funToggleRegister() => coreToggleRegister();

  funToggleReRegister() => coreToggleReRegister();

  funRegisterWithUserNameEmail() => coreRegisterWithUserNameEmail();

  funLoginWithUserNameEmail() => coreLoginWithUserNameEmail();

  funSignInWithGoogle() => coreSignInWithGoogle();
}
