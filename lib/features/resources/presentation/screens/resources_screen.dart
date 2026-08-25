import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_snackbar.dart';
import '../../../bookmarks/presentation/providers/bookmarks_provider.dart';
import '../providers/resources_provider.dart';
import '../widgets/resource_card.dart';

class ResourcesScreen extends ConsumerStatefulWidget {
  const ResourcesScreen({super.key});

  @override
  ConsumerState<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends ConsumerState<ResourcesScreen> {
  final _scrollController = ScrollController();

  static const _subjects = [
    'Mathematics',
    'Physical Sciences',
    'Life Sciences',
    'English HL',
    'Accounting',
    'Geography',
    'History',
    'Business Studies',
    'IT / CAT',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 200) {
      ref.read(resourcesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final resourcesAsync = ref.watch(resourcesProvider);
    final notifier = ref.read(resourcesProvider.notifier);
    final selectedSubject = ref.watch(subjectFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Resources', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          _buildSubjectFilters(selectedSubject),
          Expanded(
            child: resourcesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _buildErrorState(error, notifier),
              data: (resources) {
                if (resources.isEmpty) {
                  return _buildEmptyState();
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    try {
                      await notifier.refresh();
                    } catch (e) {
                      if (context.mounted) StatusSnackbar.showError(context, e, onRetry: notifier.refresh);
                    }
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: resources.length + (notifier.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= resources.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                        );
                      }
                      final resource = resources[index];
                      return ResourceCard(
                        resource: resource,
                        onTap: () => context.push(RoutePaths.resourceDetailPath(resource.id)),
                        onBookmarkTap: () => ref.read(bookmarksProvider.notifier).toggle(resource),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilters(String? selected) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip('All subjects', selected == null, () => ref.read(subjectFilterProvider.notifier).state = null),
          ..._subjects.map(
            (s) => _filterChip(s, selected == s, () => ref.read(subjectFilterProvider.notifier).state = s),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primaryDark,
        backgroundColor: AppColors.surfaceMuted,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildErrorState(Object error, ResourcesNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'Couldn\'t load resources',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => notifier.refresh(), child: const Text('Try again')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_off_outlined, size: 48, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text('No resources for this subject yet', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
