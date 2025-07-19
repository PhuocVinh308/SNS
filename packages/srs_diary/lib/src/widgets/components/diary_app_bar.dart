import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_diary/srs_diary.dart';

class DiaryAppBar extends GetView<DiaryController> {
  const DiaryAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      width: 1.sw.spMax,
      decoration: BoxDecoration(
        color: CustomColors.color06b252,
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: CustomColors.color000000.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: CustomColors.colorFFFFFF,
              size: 20.w,
            ),
          ),
          Expanded(
            child: Center(
              child: CustomText(
                'Sổ tay nhật ký canh tác'.tr.toCapitalized(),
                color: CustomColors.colorFFFFFF,
                fontWeight: CustomConsts.bold,
                fontSize: CustomConsts.appBar,
              ),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }
}
