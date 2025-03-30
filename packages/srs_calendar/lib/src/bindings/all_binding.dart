import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_calendar/srs_calendar.dart';

class AllBindingCalendar extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CalendarController());
    Get.lazyPut(() => CalendarContentController());
  }
}
