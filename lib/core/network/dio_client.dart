import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'api_exceptions.dart';

class DioClient {
  final Dio _dio;

  DioClient._internal(this._dio);

  factory DioClient() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ));

    // Add logging interceptor (simple)
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // add auth header or other headers
        // options.headers['Authorization'] = 'Bearer token';
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));

    return DioClient._internal(dio);
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<dynamic> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      return response.data;
    } else {
      final msg = response.data is Map && response.data['message'] != null
          ? response.data['message'].toString()
          : 'Unexpected server error';
      throw ApiException(msg, status);
    }
  }
}
