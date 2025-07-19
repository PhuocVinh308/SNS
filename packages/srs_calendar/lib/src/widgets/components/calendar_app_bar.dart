import 'package:flutter/material.dart';
import 'package:srs_calendar/srs_calendar.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CalendarAppBar extends GetView<CalendarController> {
  const CalendarAppBar({Key? key}) : super(key: key);

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
            color: CustomColors.color000000.withOpacity(0.1), // Màu bóng
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Nút back bên trái
          Positioned(
            left: 8.w,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: CustomColors.colorFFFFFF,
                size: 20.w,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          // Tiêu đề ở giữa
          Center(
            child: CustomText(
              'lịch thời vụ'.tr.toCapitalized(),
              color: CustomColors.colorFFFFFF,
              fontWeight: CustomConsts.bold,
              fontSize: CustomConsts.appBar,
            ),
          ),
        ],
      ),
    );
  }
}
