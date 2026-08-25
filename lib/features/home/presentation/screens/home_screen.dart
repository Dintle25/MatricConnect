import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../bookmarks/presentation/providers/bookmarks_provider.dart';
import '../../../resources/presentation/providers/resources_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _subjectCards = [
    _SubjectCard('Mathematics', Icons.calculate_rounded, AppColors.primary),
    _SubjectCard('Physical Sciences', Icons.science_rounded, AppColors.tealAccent),
    _SubjectCard('Life Sciences', Icons.eco_rounded, AppColors.goldAccent),
    _SubjectCard('English HL', Icons.menu_book_rounded, AppColors.pinkAccent),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final name = authState.maybeWhen(authenticated: (user) => user.name.split(' ').first, orElse: () => 'there');

    final resources = ref.watch(resourcesProvider).valueOrNull ?? [];
    final bookmarkCount = ref.watch(bookmarksProvider).valueOrNull?.length ?? 0;
    final recent = resources.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryDark,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hey there,', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Saved offline',
                    bookmarkCount.toString(),
                    Icons.bookmark_rounded,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard('Subjects', _subjectCards.length.toString(), Icons.grid_view_rounded, AppColors.tealAccent),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Browse by subject', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _subjectCards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final card = _subjectCards[index];
                  return GestureDetector(
                    onTap: () {
                      ref.read(subjectFilterProvider.notifier).state = card.name;
                      context.go(RoutePaths.resources);
                    },
                    child: Container(
                      width: 110,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: card.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(card.icon, color: card.color, size: 26),
                          const Spacer(),
                          Text(
                            card.name,
                            maxLines: 2,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: card.color),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fresh this week', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                TextButton(
                  onPressed: () => context.go(RoutePaths.resources),
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (recent.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Loading resources...', style: TextStyle(color: AppColors.textMuted)),
              )
            else
              ...recent.map(
                (r) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () => context.push(RoutePaths.resourceDetailPath(r.id)),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(r.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${r.subject} · ${r.fileSizeMb.toStringAsFixed(1)} MB'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _SubjectCard {
  final String name;
  final IconData icon;
  final Color color;
  const _SubjectCard(this.name, this.icon, this.color);
}
