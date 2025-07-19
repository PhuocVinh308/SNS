import 'package:flutter/material.dart';
import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CmpRegisterPageBody extends GetView<AuthenController> {
  CmpRegisterPageBody({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
        key: formKey,
        autovalidateMode: controller.autoValid,
        child: Column(
          children: [
            CustomTextField(
              title: 'tên người dùng'.tr.toCapitalized(),
              hint: 'nhập tên người dùng'.tr.toCapitalized(),
              prefixIcon: const Icon(Icons.person_rounded),
              customInputType: CustomInputType.username,
              required: true,
              controller: controller.rgUserNameController,
            ),
            .025.sh.verticalSpace,
            CustomTextField(
              title: 'email'.tr.toCapitalized(),
              hint: 'nhập email'.tr.toCapitalized(),
              prefixIcon: const Icon(Icons.email_rounded),
              customInputType: CustomInputType.email,
              required: true,
              controller: controller.rgEmailController,
            ),
            .025.sh.verticalSpace,
            CustomDropdown(
              title: 'loại tài khoản'.tr.toCapitalized(),
              hint: 'chọn loại tài khoản'.tr.toCapitalized(),
              items: controller.accountTypes,
              itemAsString: (item) {
                return (item as AccountType).name ?? 'chọn loại tài khoản'.tr.toCapitalized();
              },
              onChanged: (value) {
                controller.accountType.value = value;
              },
              required: true,
              selectedItem: controller.accountType.value,
            ),
            .025.sh.verticalSpace,
            CustomTextField(
              title: 'mật khẩu'.tr.toCapitalized(),
              hint: 'nhập mật khẩu'.tr.toCapitalized(),
              customInputType: CustomInputType.password,
              prefixIcon: const Icon(Icons.password_rounded),
              required: true,
              controller: controller.rgPasswordController,
              obscureText: controller.obscurePasswordRegisterText.value,
              toggle: () => {controller.funToggleRegister()},
              maxLines: 1,
            ),
            .025.sh.verticalSpace,
            CustomTextField(
              title: 'nhập lại mật khẩu'.tr.toCapitalized(),
              hint: 'nhập lại mật khẩu'.tr.toCapitalized(),
              customInputType: CustomInputType.password,
              prefixIcon: const Icon(Icons.password_rounded),
              required: true,
              controller: controller.rgRePasswordController,
              obscureText: controller.obscurePasswordReRegisterText.value,
              toggle: () => {controller.funToggleReRegister()},
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "vui lòng nhập lại mật khẩu!".tr.toCapitalized();
                }
                if (value != controller.rgPasswordController.text) {
                  return "mật khẩu không khớp!".tr.toCapitalized();
                }
                return null;
              },
            ),
            .03.sh.verticalSpace,
            SizedBox(
              width: 1.sw.sp,
              height: 50.sp,
              child: MaterialButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    await controller.funRegisterWithUserNameEmail();
                  } else {
                    DialogUtil.catchException(msg: "chưa nhập đầy đủ thông tin".tr.toCapitalized());
                  }
                },
                color: CustomColors.colorFC6B68,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: CustomText(
                  'đăng ký'.tr.toCapitalized(),
                  color: CustomColors.colorFFFFFF,
                  fontSize: CustomConsts.h4,
                  fontWeight: CustomConsts.medium,
                ),
              ),
            ),
            .035.sh.verticalSpace,
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "${'đã có tài khoản'.tr.toCapitalized()}? ",
                    fontSize: CustomConsts.body,
                    fontWeight: CustomConsts.regular,
                    color: CustomColors.colorFF0000,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AllRoute.mainRoute,
                        arguments: [{}],
                      );
                    },
                    child: CustomText(
                      "${'đăng nhập ngay'.tr.toCapitalized()}!",
                      fontSize: CustomConsts.body,
                      fontWeight: CustomConsts.medium,
                      color: CustomColors.color005AAB,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function? onTap;

  const _SocialButton({
    Key? key,
    required this.icon,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20.sp,
        ),
      ),
    );
  }
}
