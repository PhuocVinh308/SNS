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

  init() async {
    try {
      await _initGoogleDriveService();
    } catch (e) {
      DialogUtil.catchException(obj: e);
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
}
