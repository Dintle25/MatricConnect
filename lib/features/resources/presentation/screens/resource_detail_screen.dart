import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_snackbar.dart';
import '../../../bookmarks/presentation/providers/bookmarks_provider.dart';
import '../../domain/study_resource.dart';
import '../providers/resources_provider.dart';

/// Reachable two ways: tapping a card in the list, or a direct deep
/// link like matricconnect://resources/res-12 — GoRouter hands us
/// the id either way through the :id path parameter.
class ResourceDetailScreen extends ConsumerStatefulWidget {
  final String resourceId;

  const ResourceDetailScreen({super.key, required this.resourceId});

  @override
  ConsumerState<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends ConsumerState<ResourceDetailScreen> {
  bool _downloading = false;

  StudyResource? _findResource() {
    final fromList = ref.watch(resourcesProvider).valueOrNull ?? [];
    final fromBookmarks = ref.watch(bookmarksProvider).valueOrNull ?? [];
    for (final r in [...fromList, ...fromBookmarks]) {
      if (r.id == widget.resourceId) return r;
    }
    return null;
  }

  /// A stand-in for a real file download. It sometimes "fails" on
  /// purpose with a realistic status code, purely so the friendly
  /// error snackbar has something genuine to react to during a demo.
  Future<void> _download(StudyResource resource) async {
    setState(() => _downloading = true);
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (Random().nextInt(4) == 0) {
        final codes = [500, 503, 429];
        throw DioException(
          requestOptions: RequestOptions(path: '/download/${resource.id}'),
          response: Response(
            requestOptions: RequestOptions(path: '/download/${resource.id}'),
            statusCode: codes[Random().nextInt(codes.length)],
          ),
          type: DioExceptionType.badResponse,
        );
      }
      if (mounted) {
        StatusSnackbar.showSuccess(
          context,
          'Downloaded!',
          '${resource.title} is now saved for offline access.',
        );
      }
    } catch (e) {
      if (mounted) {
        StatusSnackbar.showError(context, e, onRetry: () => _download(resource));
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resource = _findResource();

    if (resource == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'This resource isn\'t loaded yet. Open it from the list first, or check your connection.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
        ),
      );
    }

    // Watching the provider itself (not just .notifier) means this
    // icon updates the moment a bookmark changes anywhere in the app.
    final bookmarkedIds = ref.watch(bookmarksProvider).valueOrNull?.map((r) => r.id).toSet() ?? {};
    final isBookmarked = bookmarkedIds.contains(resource.id);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => ref.read(bookmarksProvider.notifier).toggle(resource),
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 30),
            ),
            const SizedBox(height: 16),
            Text(resource.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(resource.subject), backgroundColor: AppColors.surfaceMuted),
                Chip(label: Text(resource.grade), backgroundColor: AppColors.surfaceMuted),
                Chip(label: Text(resource.typeLabel), backgroundColor: AppColors.surfaceMuted),
              ],
            ),
            const SizedBox(height: 20),
            _statRow(resource),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloading ? null : () => _download(resource),
                icon: _downloading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.download_rounded, size: 20),
                label: Text(_downloading ? 'Downloading...' : 'Download for offline'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Downloaded resources stay on your phone, so you can study without using data again.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(StudyResource resource) {
    return Row(
      children: [
        _statItem(Icons.sd_storage_rounded, '${resource.fileSizeMb.toStringAsFixed(1)} MB'),
        if (resource.pages != null) _statItem(Icons.menu_book_rounded, '${resource.pages} pages'),
        if (resource.durationMinutes != null) _statItem(Icons.play_circle_outline_rounded, '${resource.durationMinutes} min'),
        _statItem(Icons.download_for_offline_outlined, '${resource.downloadCount} downloads'),
      ],
    );
  }

  Widget _statItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
