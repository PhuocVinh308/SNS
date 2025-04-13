import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';
import 'package:get/get.dart';

class NotificationHgiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationHgiController());
  }
}
