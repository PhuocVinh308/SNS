import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumAddInitController {
  final service = ForumService();
  final DriveService _driveService = DriveService();
  bool googleDriveInitialized = false;

  GlobalKey<FormState> addNewKey = GlobalKey<FormState>();
  Rx<AutovalidateMode> validate = AutovalidateMode.onUserInteraction.obs;

  Rx<bool> options = true.obs;
  RxList<TypePostModel> typePosts = <TypePostModel>[].obs;
  Rx<TypePostModel> typePost = TypePostModel().obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  var progress = 0.0.obs;
  Rxn<String> imageOriginalPath = Rxn<String>();
  Rxn<String> imageOriginalName = Rxn<String>();
  Rxn<Uint8List> imageOriginalBytes = Rxn<Uint8List>();

  init() async {
    try {
      await _initGoogleDriveService();
      await _initTypePosts();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  initPostSeen({String? postId}) async {
    if (postId == null || postId.isEmpty) return;
    await Future.delayed(const Duration(seconds: 10), () async {
      await corePostSeen(postId: postId);
    });
  }

  corePostForum() async {
    try {
      if (addNewKey.currentState?.validate() == true) {
        DialogUtil.showLoading();
        await _getTypePost();
        ForumPostModel postModel = ForumPostModel(
          tag: typePost.value.id,
          title: titleController.value.text,
          content: contentController.value.text,
          usernameCreated: CustomGlobals().userInfo.username,
          isDelete: false,
        );

        String? fileId = await _uploadImage();
        if (fileId != null && fileId.isNotEmpty) {
          final fileUrl = await _driveService.getFileUrl(fileId);
          postModel.fileId = fileId;
          postModel.fileUrl = fileUrl;
        } else {
          postModel.fileId = "";
          postModel.fileUrl = "";
        }
        DialogUtil.hideLoading();
        DialogUtil.catchException(msg: "${"đăng tin thành công".tr.toCapitalized()}!", status: CustomSnackBarStatus.success);
      } else {
        DialogUtil.catchException(msg: "${"chưa nhập đầy đủ thông tin".tr.toCapitalized()}!");
      }
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
    }
  }

  corePostLike({required String postId}) async {
    try {
      DialogUtil.showLoading();
      ForumLikeSeenPostModel postLikeSeenModel = ForumLikeSeenPostModel(
        postId: postId,
        usernameCreated: CustomGlobals().userInfo.username,
        isDelete: false,
      );
      final postLikeRes = await service.postForumLikeOrSeenSubCollectionToDocument(
        type: ForumLikeSeenCollectionSub.like,
        dataChild: postLikeSeenModel,
      );
      DialogUtil.hideLoading();
      return postLikeRes;
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
      rethrow;
    }
  }

  corePostSeen({required String postId}) async {
    try {
      DialogUtil.showLoading();
      ForumLikeSeenPostModel postLikeSeenModel = ForumLikeSeenPostModel(
        postId: postId,
        usernameCreated: CustomGlobals().userInfo.username,
        isDelete: false,
      );
      final postSeenRes = await service.postForumLikeOrSeenSubCollectionToDocument(
        type: ForumLikeSeenCollectionSub.seen,
        dataChild: postLikeSeenModel,
      );
      DialogUtil.hideLoading();
      return postSeenRes;
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
      rethrow;
    }
  }

  corePickImage(ImageSource src) async {
    try {
      final image = await picker.pickImage(source: src);
      if (image != null) {
        imageOriginalPath.value = image.path;
        imageOriginalName.value = image.name;
        imageOriginalBytes.value = await image.readAsBytes();
      }
    } catch (e) {
      _refreshSelect();
      DialogUtil.catchException(obj: e);
    }
  }

  _uploadImage() async {
    try {
      if (imageOriginalBytes.value != null) {
        final fileId = await _driveService.uploadFileUint8List(
          imageOriginalBytes.value!,
          imageOriginalName.value!,
          folderId: CustomConsts.googleDriveFolderId,
        );
        return fileId;
      }
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  _getTypePost() async {
    try {
      typePost.value = options.value ? typePosts.first : typePosts.last;
    } catch (e) {
      rethrow;
    }
  }

  _refreshSelect() async {
    imageOriginalPath.value = null;
    imageOriginalName.value = null;
    imageOriginalBytes.value = null;
    progress.value = 0.0;
  }

  _initGoogleDriveService() async {
    try {
      await _driveService.initialize();
      googleDriveInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  _initTypePosts() async {
    try {
      typePosts.clear();
      typePosts.value = [
        TypePostModel(
          id: "NONG_DAN",
          name: 'nông dân'.tr.toCapitalized(),
        ),
        TypePostModel(
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
