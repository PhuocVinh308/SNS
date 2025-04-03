import 'package:asxh_common/src/core/api_exceptions.dart';
import 'package:asxh_common/src/helper/string_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'snack_bar_util.dart';

class ApiUtil {
  static throwHttpException({String? message, Object? object}) {
    String msg = message ?? 'da xay ra loi!'.tr.toCapitalized();
    if (object is DioException) {
      msg = DioExceptions.fromDioException(object).message;
    }
    SnackBarUtil.showSnackBar(
      message: msg,
      isSuccess: false,
    );
  }
}
