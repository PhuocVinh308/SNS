import 'dart:developer' as dev;

import 'package:asxh_common/src/config/common_app_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  RxBool hasConnected = true.obs;
  final _connectivity = Connectivity();

  @override
  void onInit() async {
    super.onInit();
    dev.log("initialize network controller", name: CommonAppConfig.packageName);
    ConnectivityResult result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      hasConnected.value = false;
    }
  }
}
