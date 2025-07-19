import 'dart:developer';

import 'package:srs_calendar/srs_calendar.dart';
import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';

import '../bindings/all_binding.dart';

allPage() async {
  log('initialize All Page Route', name: CalendarConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRoute.mainRoute,
      page: () => const CalendarPage(),
      binding: AllBindingCalendar(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}
