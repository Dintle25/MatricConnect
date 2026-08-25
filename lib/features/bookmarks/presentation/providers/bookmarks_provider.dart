import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core_providers.dart';
import '../../../resources/domain/study_resource.dart';
import '../../../resources/presentation/providers/resources_provider.dart';

final bookmarksProvider = AsyncNotifierProvider<BookmarksNotifier, List<StudyResource>>(
  BookmarksNotifier.new,
);

/// Bookmarked resources saved on-device, so a student can open a
/// past paper they downloaded weeks ago without needing data again
/// to load the list. This is the whole point of the app.
class BookmarksNotifier extends AsyncNotifier<List<StudyResource>> {
  @override
  Future<List<StudyResource>> build() async {
    final cache = ref.watch(cacheServiceProvider);
    final raw = await cache.readBookmarksJson();
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => StudyResource.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> toggle(StudyResource resource) async {
    final current = state.valueOrNull ?? [];
    final alreadyBookmarked = current.any((r) => r.id == resource.id);

    final updated = alreadyBookmarked
        ? current.where((r) => r.id != resource.id).toList()
        : [...current, resource.copyWith(isBookmarked: true)];

    state = AsyncData(updated);
    await _persist(updated);

    // Keep the resources list's little bookmark icon in sync too.
    ref.read(resourcesProvider.notifier).toggleBookmark(resource.id);
  }

  bool isBookmarked(String id) {
    return state.valueOrNull?.any((r) => r.id == id) ?? false;
  }

  Future<void> _persist(List<StudyResource> resources) async {
    final cache = ref.read(cacheServiceProvider);
    final json = jsonEncode(resources.map((r) => r.toJson()).toList());
    await cache.saveBookmarksJson(json);
  }
}
