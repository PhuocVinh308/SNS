import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:srs_common/srs_common.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioException(DioException? e) {
    switch (e?.type) {
      case DioExceptionType.cancel:
        message = "yêu cầu tới máy chủ api đã bị hủy!".tr.toCapitalized();
        break;
      case DioExceptionType.connectionTimeout:
        message = "hết thời gian kết nối tới máy chủ api!".tr.toCapitalized();
        break;
      case DioExceptionType.receiveTimeout:
        message = "hết thời gian nhận kết nối với máy chủ api!".tr.toCapitalized();
        break;
      case DioExceptionType.badResponse:
        message = _handleError(e);
        break;
      case DioExceptionType.sendTimeout:
        message = "hết thời gian gửi kết nối với máy chủ api!".tr.toCapitalized();
        break;
      default:
        message = 'đã xảy ra lỗi!'.tr.toCapitalized();
        break;
    }
  }

  String _handleError(DioException? e) {
    if (e?.response != null && e?.response?.data != null && e?.response?.data['message'] != null) {
      return '${e?.response?.data['message']}';
    } else {
      switch (e?.response?.statusCode) {
        case 400:
          return 'cú pháp không hợp lệ!'.tr.toCapitalized();
        case 401:
          return 'không có thẩm quyền!'.tr.toCapitalized();
        case 403:
          return 'không có quyền truy cập vào phần nội dung!'.tr.toCapitalized();
        case 404:
          return 'không tìm thấy nội dung!'.tr.toCapitalized();
        case 409:
          return 'dữ liệu bị trùng lập!'.tr.toCapitalized();
        case 500:
          return 'máy chủ bận xử lý!'.tr.toCapitalized();
        case 502:
          return 'có lỗi xảy ra ở máy chủ!'.tr.toCapitalized();
        case 503:
          return 'máy chủ không khả dụng!'.tr.toCapitalized();
        default:
          return 'đã xảy ra lỗi!'.tr.toCapitalized();
      }
    }
  }

  @override
  String toString() => message;
}
