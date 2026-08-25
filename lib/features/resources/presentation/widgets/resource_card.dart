import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/study_resource.dart';

/// One row in the resources list. Color-coded by type so a student
/// scanning quickly can tell a past paper from a video without
/// reading every word.
class ResourceCard extends StatelessWidget {
  final StudyResource resource;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const ResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
    required this.onBookmarkTap,
  });

  Color get _accentColor => switch (resource.type) {
        ResourceType.pastPaper => AppColors.primary,
        ResourceType.studyGuide => AppColors.pinkAccent,
        ResourceType.video => AppColors.tealAccent,
        ResourceType.memo => AppColors.goldAccent,
      };

  IconData get _icon => switch (resource.type) {
        ResourceType.pastPaper => Icons.description_rounded,
        ResourceType.studyGuide => Icons.menu_book_rounded,
        ResourceType.video => Icons.play_circle_fill_rounded,
        ResourceType.memo => Icons.fact_check_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_icon, color: _accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        _pill(resource.typeLabel, _accentColor),
                        _metaText('${resource.subject}'),
                        _metaText('${resource.fileSizeMb.toStringAsFixed(1)} MB'),
                        if (resource.pages != null) _metaText('${resource.pages} pg'),
                        if (resource.durationMinutes != null) _metaText('${resource.durationMinutes} min'),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Uploaded ${_relativeDate(resource.uploadedAt)}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onBookmarkTap,
                icon: Icon(
                  resource.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: resource.isBookmarked ? AppColors.primaryDark : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _metaText(String text) {
    return Text('· $text', style: const TextStyle(fontSize: 11, color: AppColors.textMuted));
  }

  String _relativeDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 30) return '${diff.inDays} days ago';
    return DateFormat('d MMM yyyy').format(date);
  }
}
