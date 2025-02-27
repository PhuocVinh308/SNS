import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common_lib.dart';

class AllBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenController());
  }
}
