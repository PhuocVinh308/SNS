import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumInitController {
  Rx<bool> options = true.obs;
  final service = ForumService();
  init() async {
    try {
      await initSyncEnv();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  initSyncEnv() async {
    try {
      service.fetchFireStoreDataByCollectionSync(
        collectionPath: "tb_env",
        onListen: (snapshot) {
          var map = {
            for (var doc in snapshot.docs) doc.id: doc.data() as Map<String, dynamic>, // Gán doc.id làm key và dữ liệu làm value
          };
          var modelValue = DriveServiceModel.fromJson(map['google_drive'] ?? DriveServiceModel().toJson());
          CustomGlobals().setDriveServiceModel(modelValue);
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
