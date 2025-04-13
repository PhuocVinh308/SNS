import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumInitController {
  Rx<bool> options = true.obs;
  RxList<ForumPostModel> forumPosts = <ForumPostModel>[].obs;

  final service = ForumService();

  final ScrollController scrollController = ScrollController();
  bool isLoading = false;

  bool get hasMore => service.hasMore;

  // search
  TextEditingController searchController = TextEditingController();

  RxList<ForumPostModel> forumSearchPosts = <ForumPostModel>[].obs;
  final ScrollController scrollSearchController = ScrollController();
  bool isSearchLoading = false;
  bool get hasMoreSearch => service.hasMoreSearch;

  init() async {
    try {
      await initSyncEnv();
      await initScrollController();
      await initScrollSearchController();
      await initSyncForumPost();
      await initSyncForumSearchPost();
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
      final newPosts = await service.fetchForumPosts(tag: options.value ? "NONG_DAN" : "VAT_TU");
      // final newPosts = await service.fetchForumPosts();
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

  coreChangeTypePost() async => await initSyncForumPost();

  coreClearSearch() async {
    searchController.clear();
    forumSearchPosts.clear();
  }

  initScrollSearchController() async {
    try {
      scrollSearchController.addListener(() {
        if (scrollSearchController.position.pixels >= scrollSearchController.position.maxScrollExtent - 200) {
          fetchMoreSearchPosts();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initSyncForumSearchPost() async {
    forumSearchPosts.clear();
    service.resetSearchPagination();
    await fetchMoreSearchPosts();
  }

  Future<void> fetchMoreSearchPosts() async {
    if (isSearchLoading || !service.hasMoreSearch) return;
    isSearchLoading = true;
    DialogUtil.showLoading();
    try {
      final newPosts = await service.fetchForumSearchPosts(keyword: searchController.value.text.trim());
      forumSearchPosts.addAll(newPosts);
    } finally {
      isSearchLoading = false;
      DialogUtil.hideLoading();
    }
  }

  coreSearchPost() async => initSyncForumSearchPost();
}
