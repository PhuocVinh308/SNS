import 'dart:developer' as dev;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:srs_common/srs_common.dart';

class NetworkController extends GetxController {
  RxBool hasConnected = true.obs;
  final _connectivity = Connectivity();

  @override
  void onInit() async {
    super.onInit();
    dev.log("initialize network controller", name: CommonConfig.packageName);
    ConnectivityResult result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      hasConnected.value = false;
    }
  }
}
