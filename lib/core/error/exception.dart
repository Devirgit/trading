import 'package:dio/dio.dart';

class ServerException implements Exception {
  const ServerException([this.type = 'unknown-error']);

  factory ServerException.fromCode(DioErrorType type) {
    switch (type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        return const ServerException('timeout-error');

      case DioErrorType.response:
        return const ServerException('response-error');

      default:
        return const ServerException('server-error');
    }
  }

  final String type;
}

class CacheException implements Exception {}
