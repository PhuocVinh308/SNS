import 'dart:developer';

import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';

import 'setting_init_controller.dart';

class SettingController extends GetxController with SettingInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: SettingConfig.packageName);
    await init();
    super.onInit();
  }

  funSignOut() async => coreSignOut();
  funChangeLanguage(bool value) => coreChangeLanguage(value);
}
