import 'package:flutter/material.dart';

import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common.dart';

class CustomReusableMbs {
  final BuildContext context;
  final Widget? child;
  final Widget? contentWidget;
  final String? title;
  final double? height;

  const CustomReusableMbs({
    Key? key,
    required this.context,
    this.child,
    this.contentWidget,
    this.title,
    this.height,
  });

  void showMbs() => _customMbs(context);

  void _customMbs(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.sp),
            topLeft: Radius.circular(10.sp),
          ),
        ),
        isScrollControlled: true,
        // isDismissible: false,
        enableDrag: false,
        useSafeArea: true,
        builder: (c) {
          return Container(
            padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp),
            height: (height ?? Get.mediaQuery.size.height * .3).sp,
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.sp),
                topLeft: Radius.circular(10.sp),
              ),
            ),
            child: Column(
              children: [
                _titleMbs(title: title ?? ''),
                SizedBox(child: child),
                contentWidget ?? const SizedBox(),
              ],
            ),
          );
        });
  }

  Widget _titleMbs({String? title}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomText(
                  title ?? '',
                  fontWeight: CustomConsts.semiBold,
                  color: CustomColors.color833162,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Positioned(
            top: -5,
            right: 0,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.close_rounded,
                color: CustomColors.color833162,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
