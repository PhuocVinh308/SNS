import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class AllBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForumController());
    Get.lazyPut(() => ForumContentController());
  }
}
