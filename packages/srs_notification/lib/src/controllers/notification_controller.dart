import 'dart:developer';

import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_notification/srs_notification.dart';

import 'notification_init_controller.dart';

class NotificationController extends GetxController with NotificationInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: NotificationConfig.packageName);
    await init();
    super.onInit();
  }

  @override
  void onClose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    thongBaoSubscription?.cancel();
    steamNotificationOnMessage?.cancel();
    steamNotificationOnMessageOpenedApp?.cancel();
    super.onClose();
  }
}
