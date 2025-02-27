import 'package:flutter/material.dart';
import 'package:srs_authen/src/widgets/components/authen_components.dart';
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
            resizeToAvoidBottomInset: false,
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
              height: 1.sh,
              width: 1.sw,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(
              //       "assets/images/login_bg.jpg",
              //     ),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const CmpLoginPageTitle(),
                        .08.sh.verticalSpace,
                        const CmpLoginPageBody(),
                      ],
                    ),
                    // Container ở góc trên phải
                    Positioned(
                      top: 10.sp,
                      left: 0,
                      child: const CmpSwitchLanguage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
