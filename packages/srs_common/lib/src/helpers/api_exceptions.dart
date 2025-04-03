import 'package:asxh_common/src/helper/string_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioException(DioException? e) {
    switch (e?.type) {
      case DioExceptionType.cancel:
        message = "yeu cau toi may chu api da bi huy!".tr.toCapitalized();
        break;
      case DioExceptionType.connectionTimeout:
        message = "het thoi gian ket noi voi may chu api!".tr.toCapitalized();
        break;
      case DioExceptionType.receiveTimeout:
        message = "het thoi gian nhan ket noi voi may chu api!".tr.toCapitalized();
        break;
      case DioExceptionType.badResponse:
        message = _handleError(e);
        break;
      case DioExceptionType.sendTimeout:
        message = "het thoi gian gui ket noi voi may chu api!".tr.toCapitalized();
        break;
      default:
        message = "da xay ra loi!".tr.toCapitalized();
        break;
    }
  }

  String _handleError(DioException? e) {
    if (e?.response != null && e?.response?.data != null && e?.response?.data['message'] != null) {
      return '${e?.response?.data['message']}';
    } else {
      switch (e?.response?.statusCode) {
        case 400:
          return 'cu phap khong hop le!'.tr.toCapitalized();
        case 401:
          return 'khong co tham quyen!'.tr.toCapitalized();
        case 403:
          return 'khong co quyen truy cap vao phan noi dung!'.tr.toCapitalized();
        case 404:
          return 'khong tim thay noi dung!'.tr.toCapitalized();
        case 409:
          return 'du lieu bi trung lap!'.tr.toCapitalized();
        case 500:
          return 'may chu dang ban xu ly!'.tr.toCapitalized();
        case 502:
          return 'co loi xay ra o may chu!'.tr.toCapitalized();
        case 503:
          return 'may chu khong kha dung!'.tr.toCapitalized();
        default:
          return 'da xay ra loi!'.tr.toCapitalized();
      }
    }
  }

  @override
  String toString() => message;
}
