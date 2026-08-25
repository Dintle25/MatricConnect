import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

/// Sticks the saved login token onto every outgoing request, so
/// individual repositories never have to remember to do it
/// themselves. One place to get this right instead of twenty.
class AuthInterceptor extends Interceptor {
  final SecureStorageService storage;

  AuthInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['X-Client'] = 'matricconnect-mobile';
    handler.next(options);
  }
}
