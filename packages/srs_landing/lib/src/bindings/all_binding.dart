import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_landing/srs_landing.dart';

class AllBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LandingController());
  }
}
