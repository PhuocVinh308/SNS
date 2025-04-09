import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';
import 'package:intl/intl.dart';

class ForumInitController {
  Rx<bool> options = true.obs;
  RxList<ForumPostModel> forumPosts = <ForumPostModel>[].obs;

  final service = ForumService();

  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool get hasMore => service.hasMore;

  init() async {
    try {
      await initSyncEnv();
      await initScrollController();
      await initSyncForumPost();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  initScrollController() async {
    try {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          fetchMorePosts();
        }
      });
    } catch (e) {
      rethrow;
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

  Future<void> initSyncForumPost() async {
    forumPosts.clear();
    service.resetPagination();
    await fetchMorePosts();
  }

  Future<void> fetchMorePosts() async {
    if (isLoading || !service.hasMore) return;
    isLoading = true;
    DialogUtil.showLoading();
    try {
      // final newPosts = await service.fetchForumPosts(tag: options.value ? "NONG_DAN" : "VAT_TU");
      final newPosts = await service.fetchForumPosts();
      forumPosts.addAll(newPosts);
    } finally {
      isLoading = false;
      DialogUtil.hideLoading();
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
