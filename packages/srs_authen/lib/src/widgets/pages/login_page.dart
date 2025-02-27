import 'package:flutter/material.dart';
import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common.dart';

class LoginPage extends GetView<AuthenController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: CustomColors.colorFFFFFF,
            // body: Container(
            //   height: 1.sh,
            //   width: 1.sw,
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //         "assets/images/login_bg.jpg",
            //       ),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       MaterialButton(
            //         onPressed: () {
            //           SnackBarUtil.showSnackBar();
            //         },
            //         color: Colors.white,
            //         child: const Text("Btn Test"),
            //       ),
            //       CustomTextField(
            //         controller: controller.tc,
            //         title: 'name',
            //         customInputType: CustomInputType.int,
            //         regex: true,
            //       )
            //     ],
            //   ),
            // ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/app_icon_android_12.png",
                    width: .4.sw.spMax,
                    height: .25.sh.spMax,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomTextTitle(
                          "xin chào!".tr.toCapitalized(),
                          fontSize: CustomConsts.h1,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomTextTitle(
                          "${"chào mừng bạn đến với ".tr.toCapitalized()}AgriGo!",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  .08.sh.verticalSpace,
                  CustomTextField(
                    title: 'email',
                    hint: 'nhập email',
                    prefixIcon: Icon(
                      Icons.email_rounded,
                    ),
                    customInputType: CustomInputType.email,
                    regex: true,
                  ),
                  .025.sh.verticalSpace,
                  CustomTextField(
                    title: 'mật khẩu',
                    hint: 'nhập mật khẩu',
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
                        child: CustomTextBody(
                          "quen mat khau",
                          textAlign: TextAlign.right,
                          fontWeight: CustomConsts.regular,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  .05.sh.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
