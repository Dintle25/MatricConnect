import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../bookmarks/presentation/providers/bookmarks_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final bookmarkCount = ref.watch(bookmarksProvider).valueOrNull?.length ?? 0;

    return authState.maybeWhen(
      authenticated: (user) => Scaffold(
        appBar: AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w800))),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryDark,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  Text('${user.grade} · ${user.school}', style: const TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(child: _statTile('Saved', bookmarkCount.toString(), Icons.bookmark_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _statTile('Downloads', user.resourcesDownloaded.toString(), Icons.download_rounded)),
              ],
            ),
            const SizedBox(height: 28),
            _menuTile(Icons.notifications_outlined, 'Notifications'),
            _menuTile(Icons.data_usage_rounded, 'Data saver mode'),
            _menuTile(Icons.help_outline_rounded, 'Help & support'),
            _menuTile(Icons.info_outline_rounded, 'About MatricConnect'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text('Log out', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
      orElse: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Widget _statTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryDark),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String label) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: () {},
    );
  }
}
