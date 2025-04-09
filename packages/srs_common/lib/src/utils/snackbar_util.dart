import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

enum CustomSnackBarStatus { success, error, warning, info }

int _snackBarAnimationTime = 1;
int _snackBarShowTime = 2;

class SnackBarUtil {
  static bool _isSnackBarVisible = false;
  static bool _isSnackBarDownloadVisible = false;

  static void showSnackBar({
    String? message,
    CustomSnackBarStatus? status,
    int? maxLine,
    Widget? trailing,
    Function? onCallback,
    int? snackBarShowTime,
  }) {
    if (!_isSnackBarVisible) {
      _isSnackBarVisible = true;
      Color? backgroundColor;
      IconData? leadingData;
      switch (status) {
        case CustomSnackBarStatus.success:
          backgroundColor = CustomColors.color638E5A;
          leadingData = Icons.check;
          break;
        case CustomSnackBarStatus.error:
          backgroundColor = CustomColors.colorFF0000;
          leadingData = Icons.cancel_outlined;
          break;
        case CustomSnackBarStatus.warning:
          backgroundColor = CustomColors.colorE89148;
          leadingData = Icons.warning_amber_outlined;
          break;
        case CustomSnackBarStatus.info:
          backgroundColor = CustomColors.color5093D1;
          leadingData = Icons.info_outline;
          break;
        default:
          backgroundColor = CustomColors.color5093D1;
          leadingData = Icons.notifications_sharp;
          break;
      }

      Get.showSnackbar(
        GetSnackBar(
          messageText: _ProgressBar(
            message,
            leadingData,
            status,
            maxLine,
            trailing,
          ),
          backgroundColor: backgroundColor,
          margin: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 10.sp),
          padding: EdgeInsets.zero,
          borderRadius: 8.sp,
          isDismissible: false,
          forwardAnimationCurve: Curves.elasticOut,
          reverseAnimationCurve: Curves.elasticOut,
          duration: Duration(seconds: snackBarShowTime ?? _snackBarShowTime),
          animationDuration: Duration(seconds: _snackBarAnimationTime),
          boxShadows: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 5,
              spreadRadius: 3,
              offset: Offset(2, 2),
            ),
          ],
        ),
      );
      Future.delayed(
        Duration(seconds: (snackBarShowTime ?? _snackBarShowTime) + 1),
        () {
          _isSnackBarVisible = false;
          onCallback?.call();
        },
      );
    }
  }

  static void showDownloadProgressSnackBar({
    required RxDouble progress,
  }) {
    if (!_isSnackBarDownloadVisible) {
      _isSnackBarDownloadVisible = true;
      Get.showSnackbar(
        GetSnackBar(
          messageText: Obx(() {
            return _ProgressWithDownloadBar(
              progress: progress.value,
              colorProcess: CustomColors.colorFFFFFF,
              colorText: CustomColors.colorFFFFFF,
            );
          }),
          backgroundColor: CustomColors.colorE89148,
          margin: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 10.sp),
          padding: EdgeInsets.zero,
          borderRadius: 8.sp,
          isDismissible: false,
          forwardAnimationCurve: Curves.elasticOut,
          reverseAnimationCurve: Curves.elasticOut,
          // duration: Duration(seconds: _snackBarShowTime),
          animationDuration: Duration(seconds: _snackBarAnimationTime),
        ),
      );
    }
  }

  static void closeDownloadProgressSnackBar() {
    _isSnackBarDownloadVisible = false;
    Get.closeCurrentSnackbar();
  }
}

class _ProgressBar extends StatefulWidget {
  final String? message;
  final IconData? leadingData;
  final CustomSnackBarStatus? status;
  final int? maxLine;
  final Widget? trailing;

  const _ProgressBar(
    this.message,
    this.leadingData,
    this.status,
    this.maxLine,
    this.trailing,
  );

  @override
  __ProgressBarState createState() => __ProgressBarState();
}

class __ProgressBarState extends State<_ProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: _snackBarShowTime),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color colorProcess = CustomColors.colorFFFFFF;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.sp),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.sp),
                child: SizedBox(
                  child: Icon(
                    widget.leadingData,
                    color: CustomColors.colorFFFFFF,
                    size: 30.sp,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.message ?? 'thông báo'.tr.toCapitalized(),
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: CustomColors.colorFFFFFF,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: widget.maxLine ?? 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.sp),
                child: SizedBox(
                  child: widget.trailing,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.sp),
          child: SizedBox(
            height: 3.sp,
            child: SizeTransition(
              sizeFactor: _animation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.sp),
                    bottomRight: Radius.circular(8.sp),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      colorProcess,
                      colorProcess.withOpacity(0.7),
                      colorProcess.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _ProgressWithDownloadBar extends StatelessWidget {
  final double progress;
  final Color colorProcess;
  final Color colorText;

  const _ProgressWithDownloadBar({
    required this.progress,
    required this.colorProcess,
    required this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    if (progress == 1.0) SnackBarUtil.closeDownloadProgressSnackBar();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.sp),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.sp),
                child: SizedBox(
                  child: Icon(
                    Icons.download,
                    color: colorText,
                    size: 30.sp,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '${'đang tải'.tr.toCapitalized()}...',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: colorText,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.sp),
                child: SizedBox(
                  child: Text(
                    "${(progress * 100).toInt()}%",
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: colorText,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.sp),
          child: SizedBox(
            height: 5.sp,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.sp),
                    bottomRight: Radius.circular(8.sp),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      colorProcess,
                      colorProcess.withOpacity(0.7),
                      colorProcess.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
