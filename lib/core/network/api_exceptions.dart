import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  factory ApiException.fromDioError(dynamic error) {
    if (error is DioException) {
      final type = error.type;
      if (type == DioExceptionType.connectionTimeout) {
        return ApiException("Connection Timeout");
      } else if (type == DioExceptionType.receiveTimeout) {
        return ApiException("Receive Timeout");
      } else if (type == DioExceptionType.badCertificate) {
        return ApiException("Bad Certificate");
      } else if (type == DioExceptionType.badResponse) {
        final status = error.response?.statusCode;
        final message = _extractMessage(error.response?.data) ?? "Bad Response";
        return ApiException(message, status);
      } else if (type == DioExceptionType.connectionError) {
        return ApiException("Connection Error - Check Internet");
      } else {
        return ApiException("Unexpected Error");
      }
    }
    return ApiException("Unexpected Error");
  }

  static String? _extractMessage(dynamic data) {
    try {
      if (data == null) return null;
      if (data is Map && data.containsKey('message')) return data['message']?.toString();
      if (data is String) return data;
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() => message;
}
