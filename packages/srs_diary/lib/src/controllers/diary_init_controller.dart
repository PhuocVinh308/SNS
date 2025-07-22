import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_diary/srs_diary.dart';
import 'package:srs_authen/srs_authen.dart' as srs_authen;

class DiaryInitController {
  final service = DiaryService();

  // global
  Rx<srs_authen.UserInfoModel> userModel = srs_authen.UserInfoModel().obs;

  init() async {
    try {
      await _initUserModel();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  _initUserModel() async {
    try {
      userModel.value = CustomGlobals().userInfo;
    } catch (e) {
      rethrow;
    }
  }

  corePostDiary() async {
    try {
      DialogUtil.showLoading();
      DiaryModel postModel = DiaryModel(
        documentIdParent: userModel.value.email,
      );
      await service.postDiary(data: postModel);
      DialogUtil.hideLoading();

      DialogUtil.catchException(
        msg: "${"thành công".tr.toCapitalized()}!",
        status: CustomSnackBarStatus.success,
        onCallback: () {
          Get.back(closeOverlays: true);
        },
        snackBarShowTime: 1,
      );
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
      rethrow;
    }
  }
}
