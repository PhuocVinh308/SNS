import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumInitController {
  Rx<bool> options = false.obs;

  init() async {
    try {} catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }
}
