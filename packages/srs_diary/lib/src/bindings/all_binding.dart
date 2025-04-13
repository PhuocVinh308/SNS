import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_diary/srs_diary.dart';

class AllBindingDiary extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiaryController());
  }
}
