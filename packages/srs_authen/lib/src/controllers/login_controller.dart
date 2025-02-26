import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common_lib.dart';

import 'login_init_controller.dart';

class LoginController extends GetxController with LoginInitController {
  @override
  void onInit() async {
    log('initialize Login Controller', name: AuthenConfig.packageName);
    super.onInit();
  }

  final TextEditingController tc = TextEditingController();
}
