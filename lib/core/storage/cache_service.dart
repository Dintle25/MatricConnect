import 'package:shared_preferences/shared_preferences.dart';

/// A small, plain JSON cache. Data costs are the whole reason this
/// app exists, so the last successful resource list is always saved
/// here — if the network fails on the next open, students still see
/// something instead of a blank screen.
class CacheService {
  static const _resourcesKey = 'cached_resources_v1';
  static const _bookmarksKey = 'bookmarked_resources_v1';

  Future<void> saveResourcesJson(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_resourcesKey, json);
  }

  Future<String?> readResourcesJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_resourcesKey);
  }

  /// Bookmarks are saved as the full resource, not just an id. That
  /// way a student can still open a bookmarked past paper's details
  /// even if it's fallen off the first page of the list by then.
  Future<void> saveBookmarksJson(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bookmarksKey, json);
  }

  Future<String?> readBookmarksJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_bookmarksKey);
  }
}
