import 'dart:io';
import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

import 'network_controller.dart';

Future<void> checkNetworkConnection() async {
  NetworkController networkController = Get.put(NetworkController());
  InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) async {
    switch (status) {
      case InternetConnectionStatus.connected:
        if (!networkController.hasConnected.value) {
          networkController.hasConnected(true);
          Future.delayed(Duration.zero, () async {
            if (Get.context != null && Get.context is BuildContext) {
              SnackBarUtil.showSnackBar(
                message: 'đã khôi phục kết nối internet!'.tr.toCapitalized(),
                trailing: const Icon(
                  Icons.signal_wifi_4_bar_sharp,
                  color: CustomColors.colorFFFFFF,
                ),
                status: CustomSnackBarStatus.success,
              );
            }
          });
        }
        break;
      case InternetConnectionStatus.disconnected:
        Future.delayed(const Duration(seconds: CustomConsts.networkCheckTime), () async {
          if (networkController.hasConnected.value) {
            if (!(await _hasConnection()) && Get.context != null && Get.context is BuildContext) {
              networkController.hasConnected(false);
              SnackBarUtil.showSnackBar(
                message: 'mất kết nối internet!'.tr.toCapitalized(),
                trailing: const Icon(
                  Icons.signal_wifi_connected_no_internet_4_sharp,
                  color: CustomColors.colorFFFFFF,
                ),
                status: CustomSnackBarStatus.error,
              );
            }
          }
        });
        break;
    }
  });
}

Future<bool> _hasConnection() async {
  try {
    var hostChecker = 'google.com';
    final result = await InternetAddress.lookup(hostChecker);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}
