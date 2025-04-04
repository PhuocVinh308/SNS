import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:srs_common/srs_common.dart';

class ApiUtil {
  static throwHttpException({String? message, Object? object}) {
    String msg = message ?? 'đã xảy ra lỗi!'.tr.toCapitalized();
    if (object is DioException) {
      msg = DioExceptions.fromDioException(object).message;
    }
    SnackBarUtil.showSnackBar(
      message: msg,
      status: CustomSnackBarStatus.error,
    );
  }
}
