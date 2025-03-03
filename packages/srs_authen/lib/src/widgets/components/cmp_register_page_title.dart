import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CmpRegisterPageTitle extends StatelessWidget {
  const CmpRegisterPageTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/app_icon_android_12_removebg.png",
          width: .4.sw.spMax,
          height: .25.sh.spMax,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomText(
                "đăng ký tài khoản".tr.toCapitalized(),
                fontSize: CustomConsts.h1,
                textAlign: TextAlign.center,
                fontWeight: CustomConsts.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
