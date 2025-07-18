import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';

class SettingUpdateInfoInitController {
  final service = SettingService();
  Rx<srs_authen.UserInfoModel> userModel = srs_authen.UserInfoModel().obs;

  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> accountTypeController = TextEditingController().obs;
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
      accountTypeController.value.clear();
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
      accountTypeController.value.text = getTypeAccount(userModel.value.userRole);
      emailController.value.text = userModel.value.email ?? '';
      phoneController.value.text = userModel.value.phone ?? '';
      addressController.value.text = userModel.value.address ?? '';
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
        srs_authen.UserInfoModel data = srs_authen.UserInfoModel(
          email: emailController.value.text,
          fullName: fullNameController.value.text,
          phone: phoneController.value.text,
          address: addressController.value.text,
        );
        await service.updateUser(data);
        final user = await service.getUser(emailController.value.text);
        CustomGlobals().setUserInfo(user);
        Get.find<SettingController>().initUserModel();
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

  String getTypeAccount(String? code) {
    return (code == "THUONG_LAI"
        ? 'thương lái'.tr.toCapitalized()
        : code == "NONG_DAN"
            ? 'nông dân'.tr.toCapitalized()
            : '');
  }
}
