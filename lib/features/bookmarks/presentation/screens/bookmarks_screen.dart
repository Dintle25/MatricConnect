import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../resources/presentation/widgets/resource_card.dart';
import '../providers/bookmarks_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved for offline', style: TextStyle(fontWeight: FontWeight.w800))),
      body: bookmarksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Something went wrong loading your bookmarks')),
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return const _EmptyBookmarks();
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final resource = bookmarks[index];
              return ResourceCard(
                resource: resource,
                onTap: () => context.push(RoutePaths.resourceDetailPath(resource.id)),
                onBookmarkTap: () => ref.read(bookmarksProvider.notifier).toggle(resource),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyBookmarks extends StatelessWidget {
  const _EmptyBookmarks();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 56, color: AppColors.textMuted),
            SizedBox(height: 14),
            Text('Nothing saved yet', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            SizedBox(height: 6),
            Text(
              'Tap the bookmark icon on any resource so you can open it later — even without data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
