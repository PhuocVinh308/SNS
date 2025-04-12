import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';

class AllBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
    Get.lazyPut(() => SettingUpdateInfoController());
  }
}
