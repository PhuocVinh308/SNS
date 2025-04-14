import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';

class SettingUpdateInfoPage extends GetView<SettingUpdateInfoController> {
  const SettingUpdateInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: CustomColors.colorFFFFFF,
            body: Column(
              children: [
                Container(
                  height: kToolbarHeight,
                  width: 1.sw.spMax,
                  padding: EdgeInsets.symmetric(horizontal: 15.sp),
                  decoration: BoxDecoration(
                    color: CustomColors.color06b252,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black12),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.color000000.withOpacity(0.1), // Màu bóng
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.angleLeft,
                              color: CustomColors.colorFFFFFF,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              'thông tin cá nhân'.tr.toCapitalized(),
                              color: CustomColors.colorFFFFFF,
                              fontWeight: CustomConsts.bold,
                              fontSize: CustomConsts.appBar,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                25.verticalSpace,
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: SingleChildScrollView(
                      child: Form(
                        key: controller.updateKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  'cập nhật thông tin cá nhân'.tr.toCapitalized(),
                                  fontSize: CustomConsts.title,
                                  fontWeight: CustomConsts.bold,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            20.verticalSpace,
                            CustomTextField(
                              hint: 'họ và tên'.tr.toCapitalized(),
                              controller: controller.fullNameController.value,
                              required: true,
                              autoValidate: controller.validate.value,
                              prefixIcon: const Icon(
                                Icons.person,
                              ),
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              hint: 'email'.tr.toCapitalized(),
                              controller: controller.emailController.value,
                              required: true,
                              autoValidate: controller.validate.value,
                              customInputType: CustomInputType.email,
                              prefixIcon: const Icon(
                                Icons.email,
                              ),
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              hint: 'số điện thoại'.tr.toCapitalized(),
                              controller: controller.phoneController.value,
                              required: true,
                              autoValidate: controller.validate.value,
                              customInputType: CustomInputType.phone,
                              prefixIcon: const Icon(
                                Icons.phone,
                              ),
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              hint: 'địa chỉ'.tr.toCapitalized(),
                              controller: controller.addressController.value,
                              required: true,
                              autoValidate: controller.validate.value,
                              prefixIcon: const Icon(
                                Icons.location_on,
                              ),
                            ),
                            15.verticalSpace,
                            SizedBox(
                              width: 1.sw.sp,
                              height: 50.sp,
                              child: MaterialButton(
                                onPressed: () async {
                                  await controller.funUpdateInfo();
                                },
                                color: CustomColors.colorFC6B68,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                ),
                                child: CustomText(
                                  'cập nhật'.tr.toCapitalized(),
                                  color: CustomColors.colorFFFFFF,
                                  fontSize: CustomConsts.h4,
                                  fontWeight: CustomConsts.medium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
