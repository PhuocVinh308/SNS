import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:srs_common/src/utils/snackbar_util.dart';
import 'package:srs_common/srs_common.dart';

class DialogUtil {
  static void showLoading({String? msg, bool? clickMaskDismiss}) {
    SmartDialog.showLoading(
      maskColor: CustomColors.color000000.withOpacity(.3),
      clickMaskDismiss: clickMaskDismiss,
      msg: msg ?? "${'đang tải'.tr.toCapitalized()}...",
    );
  }

  static void hideLoading({bool clickMaskDismiss = false}) {
    SmartDialog.dismiss();
  }

  static void catchException({
    String? msg,
    Object? obj,
    CustomSnackBarStatus? status,
    int? maxLine,
    Function? onCallback,
  }) {
    String errorMessage = 'đã xảy ra lỗi!'.tr.toCapitalized();
    SnackBarUtil.showSnackBar(
      message: msg ?? (obj ?? errorMessage).toString(),
      status: status ?? CustomSnackBarStatus.error,
      maxLine: maxLine ?? 3,
      onCallback: onCallback,
    );
  }
}
