import 'dart:async';
import 'package:dio/dio.dart';

/// School wifi and taxi-rank data are not reliable. Instead of
/// showing an error the moment one request hiccups, we quietly try
/// again a couple of times first, waiting a bit longer each time.
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 600),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = (err.requestOptions.extra['retry_attempt'] as int?) ?? 0;

    final isRetryable = _isRetryableError(err);

    if (isRetryable && attempt < maxRetries) {
      final nextAttempt = attempt + 1;
      // Wait a bit longer on each retry so we don't hammer a struggling network.
      await Future<void>.delayed(baseDelay * nextAttempt);

      final options = err.requestOptions;
      options.extra['retry_attempt'] = nextAttempt;

      try {
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioException catch (retryError) {
        return handler.next(retryError);
      }
    }

    handler.next(err);
  }

  bool _isRetryableError(DioException err) {
    // Connection issues and 5xx server errors are worth a retry.
    // A 401 or 404 will not fix itself by trying again, so skip those.
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }
    final status = err.response?.statusCode;
    return status != null && status >= 500;
  }
}
