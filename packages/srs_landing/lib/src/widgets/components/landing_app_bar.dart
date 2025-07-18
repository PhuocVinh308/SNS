import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_landing/srs_landing.dart';

class LandingAppBar extends GetView<LandingController> {
  const LandingAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.sp, bottom: 15.sp),
      child: Row(
        children: [
          SizedBox(
            width: 70.sp,
            child: Image.asset(
              "assets/images/app_icon_android_12.png",
              fit: BoxFit.cover,
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const FaIcon(
          //     FontAwesomeIcons.bars,
          //     color: CustomColors.color833162,
          //   ),
          // ),
          5.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return CustomText(
                    "${'xin chào'.tr.toCapitalized()} ${controller.getTypeAccount()} ${(controller.userModel.value.fullName ?? "").toTitleCase()}",
                    fontWeight: CustomConsts.bold,
                    fontSize: CustomConsts.h4,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  );
                }),
                CustomText(
                  "${'tận hưởng dịch vụ của chúng tôi'.tr.toCapitalized()}!",
                  fontWeight: CustomConsts.medium,
                  fontSize: CustomConsts.h5,
                  textAlign: TextAlign.left,
                  color: CustomColors.color313131.withOpacity(.7),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          // 5.horizontalSpace,
          // IconButton(
          //   onPressed: () {},
          //   icon: Stack(
          //     clipBehavior: Clip.none,
          //     children: [
          //       const FaIcon(
          //         FontAwesomeIcons.bell,
          //         color: CustomColors.color06b252,
          //       ), // Icon thông báo
          //       if (true) // Chỉ hiển thị khi có thông báo
          //         Positioned(
          //           right: -2, // Định vị ở góc phải trên
          //           top: -2,
          //           child: Container(
          //             padding: EdgeInsets.all(2.sp),
          //             decoration: BoxDecoration(
          //               color: Colors.red, // Màu nền của số thông báo
          //               shape: BoxShape.circle,
          //               border: Border.all(color: Colors.white, width: 1.5), // Viền trắng
          //             ),
          //             constraints: BoxConstraints(minWidth: 15.sp, minHeight: 15.sp),
          //             child: CustomText(
          //               '0',
          //               fontWeight: FontWeight.bold,
          //               fontSize: CustomConsts.h8,
          //               textAlign: TextAlign.center,
          //               color: CustomColors.colorFFFFFF,
          //             ),
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
