import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';
import 'package:srs_landing/srs_landing.dart' as srs_landing;

class ForumContentAppBar extends GetView<ForumContentController> {
  const ForumContentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      width: 1.sw.spMax,
      padding: EdgeInsets.symmetric(horizontal: 15.sp),
      decoration: BoxDecoration(
        color: CustomColors.color06b252,
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: CustomColors.color000000.withOpacity(0.1), // Màu bóng
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (controller.isBackMain.value) {
                    Get.offAndToNamed(
                      srs_landing.AllRoute.mainRoute,
                      arguments: [{}],
                    );
                  } else {
                    Get.back();
                  }
                },
                icon: const FaIcon(
                  FontAwesomeIcons.angleLeft,
                  color: CustomColors.colorFFFFFF,
                ),
              ),
              Expanded(
                child: CustomText(
                  'chi tiết'.tr.toCapitalized(),
                  color: CustomColors.colorFFFFFF,
                  fontWeight: CustomConsts.bold,
                  fontSize: CustomConsts.appBar,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
