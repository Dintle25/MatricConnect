import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network/dio_client.dart';
import 'storage/cache_service.dart';
import 'storage/secure_storage_service.dart';

/// Shared, app-wide providers that more than one feature needs.
/// Feature-specific providers live inside their own feature folder —
/// this file is only for the plumbing everyone shares.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return DioClient.create(storage);
});
