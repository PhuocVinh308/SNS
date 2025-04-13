import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_notification/srs_notification.dart';

class AllBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
