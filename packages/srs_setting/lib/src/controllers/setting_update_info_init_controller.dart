import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common_lib.dart';

class SettingUpdateInfoInitController {
  Rx<srs_authen.UserInfoModel> userModel = srs_authen.UserInfoModel().obs;

  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;

  GlobalKey<FormState> updateKey = GlobalKey<FormState>();
  Rx<AutovalidateMode> validate = AutovalidateMode.onUserInteraction.obs;

  init() async {
    try {
      await initUserModel();
      await initInput();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  coreResetInput() async {
    try {
      DialogUtil.showLoading();
      fullNameController.value.clear();
      emailController.value.clear();
      phoneController.value.clear();
      addressController.value.clear();
      await initInput();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    } finally {
      DialogUtil.hideLoading();
    }
  }

  initInput() async {
    try {
      fullNameController.value.text = userModel.value.fullName ?? '';
      emailController.value.text = userModel.value.email ?? '';
      phoneController.value.text = userModel.value.phone ?? '';
      addressController.value.text = userModel.value.email ?? '';
    } catch (e) {
      rethrow;
    }
  }

  initUserModel() async {
    try {
      userModel.value = CustomGlobals().userInfo;
    } catch (e) {
      rethrow;
    }
  }

  coreUpdateInfo() async {
    try {
      if (updateKey.currentState?.validate() == true) {
        DialogUtil.showLoading();

        // final postForumRes = await service.postForum(postModel);
        DialogUtil.hideLoading();
        DialogUtil.catchException(
          msg: "${"cập nhật thành công".tr.toCapitalized()}!",
          status: CustomSnackBarStatus.success,
          onCallback: () {
            Get.back(closeOverlays: true);
          },
          snackBarShowTime: 1,
        );
      } else {
        DialogUtil.catchException(msg: "${"chưa nhập đầy đủ thông tin".tr.toCapitalized()}!");
      }
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
    }
  }
}
