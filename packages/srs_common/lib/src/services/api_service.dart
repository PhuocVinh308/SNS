import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/io.dart' as io;
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class ApiService {
  dio.Dio _dio = dio.Dio();

  ApiService() {
    dio.BaseOptions options = dio.BaseOptions(
      receiveTimeout: const Duration(seconds: CustomConsts.apiReceiveTimeout),
      connectTimeout: const Duration(seconds: CustomConsts.apiConnectTimeout),
    );
    _dio = dio.Dio(options);
    _dio.httpClientAdapter = io.IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
    _dio.interceptors.clear();
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
    dio.Options? options,
    Object? data,
    dio.CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      dio.Response<dynamic> response = await _dio.get(
        api,
        queryParameters: queryParams,
        options: options ?? dio.Options(headers: {'authorization': 'Bearer ${CustomGlobals().token}'}),
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
    dio.Options? options,
    Object? data,
    dio.CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      dio.Response<dynamic> response = await _dio.post(
        api,
        queryParameters: queryParams,
        options: options ?? dio.Options(headers: {'authorization': 'Bearer ${CustomGlobals().token}'}),
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
    dio.Options? options,
    Object? data,
    dio.CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      dio.Response<dynamic> response = await _dio.put(
        api,
        queryParameters: queryParams,
        options: options ?? dio.Options(headers: {'authorization': 'Bearer ${CustomGlobals().token}'}),
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
    dio.Options? options,
    Object? data,
    dio.CancelToken? cancelToken,
  }) async {
    try {
      dio.Response<dynamic> response = await _dio.delete(
        api,
        queryParameters: queryParams,
        options: options ?? dio.Options(headers: {'authorization': 'Bearer ${CustomGlobals().token}'}),
        data: data,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
