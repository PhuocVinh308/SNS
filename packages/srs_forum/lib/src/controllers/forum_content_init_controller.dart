import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';
import 'package:intl/intl.dart';

class ForumContentInitController {
  final service = ForumService();
  final DriveService _driveService = DriveService();
  bool googleDriveInitialized = false;

  GlobalKey<FormState> replyKey = GlobalKey<FormState>();
  Rx<AutovalidateMode> validate = AutovalidateMode.onUserInteraction.obs;

  bool isBackMain = false;
  ForumPostModel data = ForumPostModel();
  TextEditingController replyController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  var progress = 0.0.obs;
  Rxn<String> imageOriginalPath = Rxn<String>();
  Rxn<String> imageOriginalName = Rxn<String>();
  Rxn<Uint8List> imageOriginalBytes = Rxn<Uint8List>();

  RxList<ForumPostChildModel> postCmts = <ForumPostChildModel>[].obs;

  // like
  Rx<ForumPostChildModel> currentPostLikeModel = ForumPostChildModel().obs;

  init() async {
    try {
      DialogUtil.showLoading();
      await _initGoogleDriveService();
      await initSyncCmt();
      await initSyncLike();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    } finally {
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

  initPostSeen({String? postId}) async {
    if (postId == null || postId.isEmpty) return;
    await Future.delayed(const Duration(seconds: 10), () async {
      await corePostSeen(postId: postId);
    });
  }

  corePostSeen({required String postId}) async {
    try {
      DialogUtil.showLoading();
      ForumPostChildModel postSeenModel = ForumPostChildModel(
        postId: postId,
        usernameCreated: CustomGlobals().userInfo.username,
        fullNameCreated: CustomGlobals().userInfo.fullName,
        isDelete: false,
      );
      final postSeenRes = await service.postForumChild(
        type: ForumCollectionSub.seen,
        dataChild: postSeenModel,
      );
      DialogUtil.hideLoading();
      return postSeenRes;
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
      rethrow;
    }
  }

  corePostReply() async {
    try {
      if (replyKey.currentState?.validate() == true && replyController.value.text.trim().isNotEmpty) {
        DialogUtil.showLoading();
        ForumPostChildModel postModel = ForumPostChildModel(
          postId: data.documentId,
          usernameCreated: CustomGlobals().userInfo.username,
          fullNameCreated: CustomGlobals().userInfo.fullName,
          content: replyController.value.text,
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
        final postReplyRes = await service.postForumChild(
          type: ForumCollectionSub.cmt,
          dataChild: postModel,
        );
        replyController.clear();
        coreRefreshSelect();
        DialogUtil.hideLoading();
        DialogUtil.catchException(msg: "${"bình luận thành công".tr.toCapitalized()}!", status: CustomSnackBarStatus.success);
      } else {
        DialogUtil.catchException(msg: "${"chưa nhập đầy đủ thông tin".tr.toCapitalized()}!");
      }
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
      rethrow;
    }
  }

  coreRefreshSelect() {
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

  corePickImage(ImageSource src) async {
    try {
      final image = await picker.pickImage(source: src);
      if (image != null) {
        imageOriginalPath.value = image.path;
        imageOriginalName.value = image.name;
        imageOriginalBytes.value = await image.readAsBytes();
      }
    } catch (e) {
      coreRefreshSelect();
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

  coreGetTagPost() {
    if (data.tag == null || data.tag == '') return 'đang cập nhật...'.tr.toCapitalized();

    switch (data.tag) {
      case 'NONG_DAN':
        return '#${'nông dân'.tr.toCapitalized()}';
      case 'VAT_TU':
        return '#${'vật tư'.tr.toCapitalized()}';
      default:
        return 'đang cập nhật...'.tr.toCapitalized();
    }
  }

  initSyncCmt() async {
    try {
      service.fetchCmtSync(
        documentId: data.documentId,
        onListen: (snapshot) async {
          final cmts = await Future.wait(snapshot.docs.map(_mapDocToCmt));
          postCmts.value = cmts.toList();
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ForumPostChildModel> _mapDocToCmt(DocumentSnapshot doc) async {
    final cmt = ForumPostChildModel.fromJson(doc.data() as Map<String, dynamic>);

    final subCounts = await Future.wait([
      doc.reference.collection('ct_like').count().get(),
    ]);
    cmt.countLike = subCounts[0].count ?? 0;

    return cmt;
  }

  initSyncLike() async {
    try {
      service.fetchLikeSync(
        documentId: data.documentId,
        onListen: (snapshot) async {
          final likes = await Future.wait(snapshot.docs.map(_mapDocToCmt));
          currentPostLikeModel.value = likes.first;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ForumPostChildModel> _mapDocToLike(DocumentSnapshot doc) async {
    final like = ForumPostChildModel.fromJson(doc.data() as Map<String, dynamic>);
    return like;
  }

  coreGetCurrentPostLike() {
    try {
      return (currentPostLikeModel.value.documentId == null ? false : true);
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  corePostLikePost() async {
    try {
      DialogUtil.showLoading();
      ForumPostChildModel postModel = ForumPostChildModel(
        postId: data.documentId,
        usernameCreated: CustomGlobals().userInfo.username,
        fullNameCreated: CustomGlobals().userInfo.fullName,
        isDelete: false,
      );
      if (currentPostLikeModel.value.documentId == null) {
        final postLikeRes = await service.postForumChild(
          type: ForumCollectionSub.like,
          dataChild: postModel,
        );
        currentPostLikeModel.value = ForumPostChildModel(documentId: postLikeRes.postLikeFormat);
      } else {
        final deleteLikeRes = await service.deleteForumChildDocument(
          type: ForumCollectionSub.like,
          dataChild: postModel,
          documentIdChild: currentPostLikeModel.value.documentId,
        );
        currentPostLikeModel.value = ForumPostChildModel();
      }
    } catch (e) {
      DialogUtil.catchException(obj: e);
    } finally {
      DialogUtil.hideLoading();
    }
  }
}
