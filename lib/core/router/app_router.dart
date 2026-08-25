import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/resources/presentation/screens/resource_detail_screen.dart';
import '../../features/resources/presentation/screens/resources_screen.dart';
import '../widgets/app_scaffold_shell.dart';
import 'route_paths.dart';

/// A tiny helper that lets GoRouter listen to a Riverpod provider.
/// Without this, GoRouter has no way of knowing "hey, the user just
/// logged in, please redirect them" — it only re-checks redirect
/// logic when something notifies it.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggingIn = state.matchedLocation == RoutePaths.login;

      return authState.when(
        unknown: () => null, // Still checking secure storage, don't bounce anywhere yet.
        unauthenticated: () => isLoggingIn ? null : RoutePaths.login,
        authenticated: (_) => isLoggingIn ? RoutePaths.home : null,
      );
    },
    routes: [
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // StatefulShellRoute keeps a separate navigation stack per tab
      // and the bottom bar visible across all of them — this is what
      // makes tab switching instant instead of rebuilding every time.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppScaffoldShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: RoutePaths.home, builder: (context, state) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.resources,
                builder: (context, state) => const ResourcesScreen(),
                routes: [
                  // Nested under /resources so a deep link like
                  // /resources/res-4 opens the detail page directly,
                  // with Resources still selected in the tab bar.
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ResourceDetailScreen(resourceId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: RoutePaths.bookmarks, builder: (context, state) => const BookmarksScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: RoutePaths.profile, builder: (context, state) => const ProfileScreen()),
            ],
          ),
        ],
      ),
    ],
  );
});
