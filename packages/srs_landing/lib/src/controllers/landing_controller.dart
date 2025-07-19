import 'dart:developer';

import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_landing/srs_landing.dart';

import 'landing_init_controller.dart';

class LandingController extends GetxController with LandingInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: LandingConfig.packageName);
    await init();
    super.onInit();
  }

  funGetTimeCreate(String? value) => coreGetTimeCreate(value);

  @override
  void onReady() async {
    await initSyncEnv();
    super.onReady();
  }
}
