import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

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
                // _titleMbs(title: title ?? ''),
                // SizedBox(child: child),
                // contentWidget ?? const SizedBox(),
                _titleMbs(title: title ?? ''),
                Expanded(
                  child: child ?? const SizedBox(),
                ),
                contentWidget ?? const SizedBox(),
              ],
            ),
          );
        });
  }

  Widget _titleMbs({String? title}) {
    return Container(
      height: 60.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.sp),
          topRight: Radius.circular(10.sp),
        ),
      ),
      child: Stack(
        children: [
          Container(
            alignment: FractionalOffset.topCenter,
            padding: EdgeInsets.only(top: 5.sp),
            child: Container(
              height: 3.sp,
              width: 50.sp,
              decoration: BoxDecoration(
                color: CustomColors.color00499B,
                borderRadius: BorderRadius.all(
                  Radius.circular(3.sp),
                ),
              ),
            ),
          ),
          Container(
            alignment: FractionalOffset.center,
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              title ?? '',
              style: GoogleFonts.roboto(
                color: CustomColors.color7047EB,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: FractionalOffset.topRight,
            padding: EdgeInsets.only(top: 5.sp, right: 5.sp),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(5.sp),
              ),
              child: Material(
                color: CustomColors.color00499B,
                child: SizedBox(
                  height: 25.sp,
                  width: 25.sp,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    iconSize: 20.sp,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: CustomColors.colorFFFFFF,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
