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
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              height: 1.sh,
              width: 1.sw,
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
