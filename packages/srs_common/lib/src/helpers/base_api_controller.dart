import 'dart:io';

import 'package:asxh_common/src/config/common_app_config.dart';
import 'package:asxh_common/src/core/auth_interceptor.dart';
import 'package:asxh_common/src/utils/common_util.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class BaseApiController {
  Dio _dio = Dio();

  BaseApiController() {
    BaseOptions options = BaseOptions(
      receiveTimeout: Duration(seconds: CommonAppConfig.apiReceiveTimeout),
      connectTimeout: Duration(seconds: CommonAppConfig.apiConnectTimeout),
    );
    _dio = Dio(options);
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
    _dio.interceptors.clear();
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(AwesomeDioInterceptor(
      logRequestTimeout: false,
      logRequestHeaders: false,
      logResponseHeaders: false,
    ));
    _dio.interceptors.add(CurlLoggerDioInterceptor());
  }

  Future<dynamic> getHttp({
    required String api,
    Map<String, dynamic>? queryParams,
    Options? options,
    Object? data,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      Response<dynamic> response = await _dio.get(
        api,
        queryParameters: queryParams,
        options: options ?? Options(headers: {'authorization': 'Bearer ${CommonUtil.accessToken}'}),
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postHttp({
    required String api,
    Map<String, dynamic>? queryParams,
    Options? options,
    Object? data,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      Response<dynamic> response = await _dio.post(
        api,
        queryParameters: queryParams,
        options: options ?? Options(headers: {'authorization': 'Bearer ${CommonUtil.accessToken}'}),
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putHttp({
    required String api,
    Map<String, dynamic>? queryParams,
    Options? options,
    Object? data,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      Response<dynamic> response = await _dio.put(
        api,
        queryParameters: queryParams,
        options: options ?? Options(headers: {'authorization': 'Bearer ${CommonUtil.accessToken}'}),
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteHttp({
    required String api,
    Map<String, dynamic>? queryParams,
    Options? options,
    Object? data,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<dynamic> response = await _dio.delete(
        api,
        queryParameters: queryParams,
        options: options ?? Options(headers: {'authorization': 'Bearer ${CommonUtil.accessToken}'}),
        data: data,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
