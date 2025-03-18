import 'package:flutter/material.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumAddInitController {
  GlobalKey<FormState> addNewKey = GlobalKey<FormState>();
  Rx<AutovalidateMode> validate = AutovalidateMode.onUserInteraction.obs;
  RxList<TypePost> typePosts = <TypePost>[].obs;
  Rx<TypePost> typePost = TypePost().obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  init() async {
    try {
      await _initTypePosts();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  _initTypePosts() async {
    try {
      typePosts.clear();
      typePosts.value = [
        TypePost(
          id: "NONG_DAN",
          name: 'nông dân'.tr.toCapitalized(),
        ),
        TypePost(
          id: "VAT_TU",
          name: 'vật tư'.tr.toCapitalized(),
        ),
      ];
      typePost.value = typePosts.first;
    } catch (e) {
      rethrow;
    }
  }
}
