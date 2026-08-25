import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The bottom tab bar that stays on screen while the student moves
/// between Home, Resources, Bookmarks, and Profile. Each tab keeps
/// its own scroll position and navigation stack — switching tabs and
/// coming back doesn't reset you to the top of a list.
class AppScaffoldShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffoldShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the tab you're already on jumps back to its root
          // instead of doing nothing, same as most familiar apps.
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder_rounded),
            label: 'Resources',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
