import 'package:flutter/material.dart';
import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CmpLoginPageBody extends GetView<AuthenController> {
  const CmpLoginPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          title: 'email'.tr.toCapitalized(),
          hint: 'nhập email'.tr.toCapitalized(),
          prefixIcon: Icon(
            Icons.email_rounded,
          ),
          customInputType: CustomInputType.email,
          regex: true,
        ),
        .025.sh.verticalSpace,
        CustomTextField(
          title: 'mật khẩu'.tr.toCapitalized(),
          hint: 'nhập mật khẩu'.tr.toCapitalized(),
          customInputType: CustomInputType.password,
          prefixIcon: Icon(
            Icons.password_rounded,
          ),
          suffixIcon: Icon(
            Icons.visibility_rounded,
          ),
          regex: true,
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
            onPressed: () {},
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
        CustomText(
          'hoặc tiếp tục với'.tr.toCapitalized(),
          fontSize: CustomConsts.h6,
          fontWeight: CustomConsts.regular,
          color: CustomColors.colorFF0000,
        ),
        .03.sh.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(
              icon: FontAwesomeIcons.google,
              color: Colors.red,
              onTap: () {},
            ),
            // SizedBox(width: 15.sp),
            // SocialButton(
            //   icon: FontAwesomeIcons.apple,
            //   color: Colors.black,
            //   onTap: () {},
            // ),
            // SizedBox(width: 15.sp),
            // SocialButton(
            //   icon: FontAwesomeIcons.facebook,
            //   color: Colors.blue,
            //   onTap: () {},
            // ),
          ],
        ),
        .03.sh.verticalSpace,
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
                onTap: () {},
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
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function? onTap;

  const SocialButton({
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
