import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core_providers.dart';
import '../../data/resources_remote_data_source.dart';
import '../../data/resources_repository.dart';
import '../../domain/study_resource.dart';

final resourcesRepositoryProvider = Provider<ResourcesRepository>((ref) {
  // Swap MockResourcesRemoteDataSource() for
  // DioResourcesRemoteDataSource(ref.watch(dioProvider)) the day a
  // real backend exists — nothing else in the app needs to change.
  final remote = MockResourcesRemoteDataSource();
  final cache = ref.watch(cacheServiceProvider);
  return ResourcesRepository(remote, cache);
});

final resourcesProvider = AsyncNotifierProvider<ResourcesNotifier, List<StudyResource>>(
  ResourcesNotifier.new,
);

/// The subject the student has filtered by, or null for "All subjects".
final subjectFilterProvider = StateProvider<String?>((ref) => null);

class ResourcesNotifier extends AsyncNotifier<List<StudyResource>> {
  int _page = 0;
  bool hasMore = true;
  bool isLoadingMore = false;

  ResourcesRepository get _repo => ref.read(resourcesRepositoryProvider);
  String? get _subject => ref.read(subjectFilterProvider);

  @override
  Future<List<StudyResource>> build() async {
    _page = 0;
    hasMore = true;

    // Watching the filter means picking a new subject rebuilds this
    // provider automatically, going through the same cache-then-network
    // path below.
    ref.watch(subjectFilterProvider);

    if (_subject == null) {
      final cached = await _repo.readCachedFirstPage();
      if (cached.isNotEmpty) {
        // Show what we saved last time immediately...
        unawaited(_refreshFirstPageInBackground());
        return cached;
      }
    }

    final page = await _repo.fetchPage(page: 0, subjectFilter: _subject);
    hasMore = page.hasMore;
    return page.items;
  }

  /// ...then quietly swap in fresh data once the network responds,
  /// without flashing a loading spinner over content the student is
  /// already reading. If the network fails, we just keep the cache —
  /// no error shown, since something is still on screen.
  Future<void> _refreshFirstPageInBackground() async {
    try {
      final page = await _repo.fetchPage(page: 0, subjectFilter: _subject);
      hasMore = page.hasMore;
      state = AsyncData(page.items);
    } catch (_) {
      // Swallow silently — cached data is still valid to show.
    }
  }

  Future<void> refresh() async {
    _page = 0;
    state = const AsyncLoading<List<StudyResource>>().copyWithPrevious(state);
    try {
      final page = await _repo.fetchPage(page: 0, subjectFilter: _subject);
      hasMore = page.hasMore;
      state = AsyncData(page.items);
    } catch (e, st) {
      state = AsyncError<List<StudyResource>>(e, st).copyWithPrevious(state);
      rethrow;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;
    final current = state.valueOrNull ?? [];
    isLoadingMore = true;
    try {
      final nextPage = _page + 1;
      final page = await _repo.fetchPage(page: nextPage, subjectFilter: _subject);
      _page = nextPage;
      hasMore = page.hasMore;
      state = AsyncData([...current, ...page.items]);
    } finally {
      isLoadingMore = false;
    }
  }

  void toggleBookmark(String id) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData([
      for (final r in current)
        if (r.id == id) r.copyWith(isBookmarked: !r.isBookmarked) else r,
    ]);
  }
}
