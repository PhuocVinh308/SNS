import 'package:flutter/material.dart';
import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CmpLoginPageBody extends GetView<AuthenController> {
  const CmpLoginPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          CustomTextField(
            title: 'email'.tr.toCapitalized(),
            hint: 'nhập email'.tr.toCapitalized(),
            prefixIcon: const Icon(Icons.email_rounded),
            customInputType: CustomInputType.email,
            regex: true,
            controller: controller.emailController,
          ),
          .025.sh.verticalSpace,
          CustomTextField(
            title: 'mật khẩu'.tr.toCapitalized(),
            hint: 'nhập mật khẩu'.tr.toCapitalized(),
            customInputType: CustomInputType.password,
            prefixIcon: const Icon(Icons.password_rounded),
            regex: true,
            controller: controller.passwordController,
            obscureText: controller.obscurePasswordLoginText.value,
            toggle: () => {controller.funToggleLogin()},
            maxLines: 1,
          ),
          .03.sh.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomText(
                  "${"quên mật khẩu".tr.toCapitalized()}?",
                  textAlign: TextAlign.right,
                  fontWeight: CustomConsts.medium,
                  maxLines: 2,
                  color: CustomColors.colorE89148,
                  fontSize: CustomConsts.body,
                ),
              ),
            ],
          ),
          .03.sh.verticalSpace,
          SizedBox(
            width: 1.sw.sp,
            height: 50.sp,
            child: MaterialButton(
              onPressed: () async {
                await controller.funLoginWithUserNameEmail();
              },
              color: CustomColors.colorFC6B68,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: CustomText(
                'đăng nhập'.tr.toCapitalized(),
                color: CustomColors.colorFFFFFF,
                fontSize: CustomConsts.h4,
                fontWeight: CustomConsts.medium,
              ),
            ),
          ),
          .035.sh.verticalSpace,
          // CustomText(
          //   'hoặc tiếp tục với'.tr.toCapitalized(),
          //   fontSize: CustomConsts.h6,
          //   fontWeight: CustomConsts.regular,
          //   color: CustomColors.colorFF0000,
          // ),
          // .03.sh.verticalSpace,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _SocialButton(
          //       icon: FontAwesomeIcons.google,
          //       color: Colors.red,
          //       onTap: () async {
          //         await controller.funSignInWithGoogle();
          //       },
          //     ),
          //   ],
          // ),
          // .03.sh.verticalSpace,
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "${'chưa có tài khoản'.tr.toCapitalized()}? ",
                  fontSize: CustomConsts.body,
                  fontWeight: CustomConsts.regular,
                  color: CustomColors.colorFF0000,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AllRoute.registerRoute,
                      arguments: [{}],
                    );
                  },
                  child: CustomText(
                    "${'đăng ký ngay'.tr.toCapitalized()}!",
                    fontSize: CustomConsts.body,
                    fontWeight: CustomConsts.medium,
                    color: CustomColors.color005AAB,
                  ),
                ),
              ],
            ),
          ),
        ],
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
