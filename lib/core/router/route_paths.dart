/// Every route path as a constant. Typing '/resources' wrong in five
/// different files is how deep links quietly break, so we type it
/// once here instead.
class RoutePaths {
  RoutePaths._();

  static const login = '/login';
  static const home = '/home';
  static const resources = '/resources';
  static const resourceDetail = '/resources/:id';
  static const bookmarks = '/bookmarks';
  static const profile = '/profile';

  static String resourceDetailPath(String id) => '/resources/$id';
}
