import 'dart:developer';

import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';
import 'setting_update_info_init_controller.dart';

class SettingUpdateInfoController extends GetxController with SettingUpdateInfoInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: SettingConfig.packageName);
    await init();
    super.onInit();
  }

  funUpdateInfo() async => await coreUpdateInfo();
}
