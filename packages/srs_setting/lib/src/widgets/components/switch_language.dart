import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';

class SwitchLanguage extends GetView<SettingController> {
  const SwitchLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double swLangHeight = 30.sp;
    double swLangWidth = 40.sp;
    double swLangRadius = 15.sp;
    return Obx(() {
      return Container(
        width: swLangWidth * 2,
        height: swLangHeight + 5.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(swLangRadius),
          color: Colors.grey[300],
        ),
        child: Stack(
          children: [
            // Nền trượt động
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: controller.language.value ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: swLangWidth,
                height: swLangHeight,
                decoration: BoxDecoration(
                  color: CustomColors.colorFFFFFF,
                  borderRadius: BorderRadius.circular(swLangRadius),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.color000000.withOpacity(.04),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Nút chọn VN
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  controller.language.value = true;
                  controller.funChangeLanguage(true);
                },
                child: Container(
                  width: swLangWidth,
                  height: swLangHeight,
                  alignment: Alignment.center,
                  child: Text(
                    "🇻🇳",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: controller.language.value ? Colors.red : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
            // Nút chọn US
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  controller.language.value = false;
                  controller.funChangeLanguage(false);
                },
                child: Container(
                  width: swLangWidth,
                  height: swLangHeight,
                  alignment: Alignment.center,
                  child: Text(
                    "🇺🇸",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: controller.language.value ? Colors.black54 : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
