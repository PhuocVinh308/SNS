import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_diary/srs_diary.dart';

class DiaryInitController {
  Rx<bool> options = false.obs;

  init() async {
    try {} catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }
}
