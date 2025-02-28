import 'package:flutter/material.dart';
import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common.dart';

class RegisterPage extends GetView<AuthenController> {
  const RegisterPage({Key? key}) : super(key: key);

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
