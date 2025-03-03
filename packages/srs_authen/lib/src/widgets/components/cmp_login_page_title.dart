import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CmpLoginPageTitle extends StatelessWidget {
  const CmpLoginPageTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          // "assets/images/app_icon_android_12.png",
          "assets/images/app_icon_android_12_removebg.png",
          width: .4.sw.spMax,
          height: .25.sh.spMax,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomText(
                "${"xin chào".tr.toCapitalized()}!",
                fontSize: CustomConsts.h1,
                textAlign: TextAlign.center,
                fontWeight: CustomConsts.bold,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomText(
                "${"chào mừng bạn đến với".tr.toCapitalized()} AgriGo!",
                textAlign: TextAlign.center,
                maxLines: 2,
                fontWeight: CustomConsts.semiBold,
                fontSize: CustomConsts.title,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
