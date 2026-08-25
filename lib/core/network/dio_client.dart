import 'package:dio/dio.dart';
import '../config/flavor_config.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';
import 'retry_interceptor.dart';

/// Builds one Dio instance for the whole app. Every repository shares
/// this instance so headers, retries, and timeouts behave the same
/// way everywhere instead of being copy-pasted per feature.
class DioClient {
  static Dio create(SecureStorageService storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: FlavorConfig.instance.baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(storage),
      RetryInterceptor(dio: dio),
      if (FlavorConfig.isDev)
        LogInterceptor(requestBody: false, responseBody: false, error: true),
    ]);

    return dio;
  }
}
