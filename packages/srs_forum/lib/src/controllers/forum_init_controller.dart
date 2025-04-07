import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';
import 'package:intl/intl.dart';

class ForumInitController {
  Rx<bool> options = true.obs;
  RxList<ForumPostModel> forumPosts = <ForumPostModel>[].obs;
  RxList<ForumPostModel> forumPostsSorted = <ForumPostModel>[].obs;

  final service = ForumService();
  init() async {
    try {
      await initSyncEnv();
      await initSyncForumPost();
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

  initSyncForumPost() async {
    try {
      service.fetchFireStoreDataByCollectionSync(
        collectionPath: "tb_forum",
        // onListen: (snapshot) {
        //   forumPosts.value = snapshot.docs.map((doc) => ForumPostModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
        // },
        onListen: (snapshot) async {
          final posts = await Future.wait(
            snapshot.docs.map((doc) async {
              final post = ForumPostModel.fromJson(doc.data() as Map<String, dynamic>);
              // Chỉ lấy số lượng comments
              final commentsCount = (await doc.reference.collection('ct_cmt').count().get()).count ?? 0;
              post.countCmt = commentsCount;
              // Chỉ lấy số lượng like
              final likesCount = (await doc.reference.collection('ct_like').count().get()).count ?? 0;
              post.countLike = likesCount;
              // Chỉ lấy số lượng like
              final seensCount = (await doc.reference.collection('ct_seen').count().get()).count ?? 0;
              post.countSeen = seensCount;
              return post;
            }),
          );
          forumPosts.value = posts;
          if (options.value) {
            var list = forumPosts.toList();
            list.removeWhere((data) => data.tag != "NONG_DAN");
            forumPostsSorted.value = list.toList();
          } else {
            var list = forumPosts.toList();
            list.removeWhere((data) => data.tag != "VAT_TU");
            forumPostsSorted.value = list.toList();
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  coreGetTimeCreate(String? value) {
    if (value == null) return 'đang cập nhật...'.tr.toCapitalized();
    try {
      // Phân tích chuỗi ngày giờ
      DateTime dateTime = DateTime.parse(value);
      // Định dạng giờ: HH:mm:ss (24h)
      String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
      // Định dạng ngày: dd/MM/yyyy
      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
      // Kết hợp lại
      String finalFormattedDateTime = "$formattedTime $formattedDate";
      return finalFormattedDateTime;
    } catch (e) {
      return 'đang cập nhật...'.tr.toCapitalized();
    }
  }

  coreChangeTypePost() async {
    try {
      DialogUtil.showLoading();
      Future.delayed(const Duration(milliseconds: 300), () async {
        await initSyncForumPost();
      });
      DialogUtil.hideLoading();
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
    }
  }
}
