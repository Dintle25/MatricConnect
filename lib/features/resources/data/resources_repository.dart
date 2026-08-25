import 'dart:convert';
import '../../../core/storage/cache_service.dart';
import '../domain/resource_page.dart';
import '../domain/study_resource.dart';
import 'resources_remote_data_source.dart';

/// Sits between the provider and the raw data source. Its job is
/// "cache-then-network" for page 0 only: show whatever we saved last
/// time immediately, then quietly replace it once fresh data arrives.
/// Later pages (page 1, 2, ...) always go straight to the network —
/// there's no sensible "cached page 3" to fall back to.
class ResourcesRepository {
  final ResourcesRemoteDataSource _remote;
  final CacheService _cache;

  ResourcesRepository(this._remote, this._cache);

  /// Whatever was cached from the last successful first page, or an
  /// empty list if the app has never fetched anything before.
  Future<List<StudyResource>> readCachedFirstPage() async {
    final raw = await _cache.readResourcesJson();
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => StudyResource.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ResourcePage> fetchPage({required int page, String? subjectFilter}) async {
    final result = await _remote.fetchResources(page: page, subjectFilter: subjectFilter);

    if (page == 0 && subjectFilter == null) {
      final encoded = jsonEncode(result.items.map((r) => r.toJson()).toList());
      await _cache.saveResourcesJson(encoded);
    }

    return result;
  }
}
