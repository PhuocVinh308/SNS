import 'dart:developer';

import 'package:srs_forum/srs_forum.dart';

import 'forum_init_controller.dart';
import 'package:srs_common/srs_common_lib.dart';

class ForumController extends GetxController with ForumInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: ForumConfig.packageName);
    await init();
    super.onInit();
  }
}
