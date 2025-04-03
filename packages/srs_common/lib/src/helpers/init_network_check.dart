import 'dart:io';

import 'package:asxh_common/src/config/common_app_config.dart';
import 'package:asxh_common/src/controller/base_util_controller.dart';
import 'package:asxh_common/src/controller/network_controller.dart';
import 'package:asxh_common/src/helper/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<void> checkNetworkConnection() async {
  NetworkController networkController = Get.put(NetworkController());
  InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) async {
    switch (status) {
      case InternetConnectionStatus.connected:
        if (!networkController.hasConnected.value) {
          networkController.hasConnected(true);
          Future.delayed(Duration.zero, () async {
            if (Get.context != null && Get.context is BuildContext) {
              BaseUtilController().showSnackBar(
                message: 'da khoi phuc ket noi internet!'.tr.toCapitalized(),
                iconLeadingSuccess: Icons.signal_wifi_4_bar_sharp,
                isSuccess: true,
              );
            }
          });
        }
        break;
      case InternetConnectionStatus.disconnected:
        Future.delayed(Duration(seconds: CommonAppConfig.networkCheckTime), () async {
          if (networkController.hasConnected.value) {
            if (!(await _hasConnection()) && Get.context != null && Get.context is BuildContext) {
              networkController.hasConnected(false);
              BaseUtilController().showSnackBar(
                message: 'mat ket noi internet!'.tr.toCapitalized(),
                iconLeadingFailed: Icons.signal_wifi_connected_no_internet_4_sharp,
                isSuccess: false,
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
