import 'dart:developer';

import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

import 'forum_content_init_controller.dart';

class ForumContentController extends GetxController with ForumContentInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: ForumConfig.packageName);
    data = Get.arguments[0]['data'] ?? ForumPostModel();
    isBackMain = Get.arguments[0]['isBackMain'] ?? false;
    await init();
    super.onInit();
  }

  funGetTimeCreate(String? value) => coreGetTimeCreate(value);
}
