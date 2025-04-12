import 'dart:developer';

import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/src/controllers/forum_add_init_controller.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumAddController extends GetxController with ForumAddInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: ForumConfig.packageName);
    await init();
    super.onInit();
  }

  funPostForum() async => await corePostForum();

  funPostLike({required String postId}) async => await corePostLike(postId: postId);

  funPickImage(ImageSource src) async => await corePickImage(src);
}
