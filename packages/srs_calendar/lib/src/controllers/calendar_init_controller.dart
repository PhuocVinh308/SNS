import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_calendar/srs_calendar.dart';

class CalendarInitController {
  Rx<bool> options = false.obs;

  init() async {
    try {} catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }
}
