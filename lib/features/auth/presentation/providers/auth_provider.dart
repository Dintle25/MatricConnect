import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core_providers.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(secureStorageProvider));
});

/// Holds the current AuthState for the whole app. GoRouter listens
/// to this (see app_router.dart) to decide whether to show the
/// login screen or the tabbed home shell.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _restoreSession();
    return const AuthState.unknown();
  }

  Future<void> _restoreSession() async {
  final repo = ref.read(authRepositoryProvider);
  final loggedIn = await repo.isLoggedIn;

  if (!loggedIn) {
    state = const AuthState.unauthenticated();
    return;
  }

  await repo.logout();
  state = const AuthState.unauthenticated();
}

  Future<void> login({required String name, required String grade, required String school}) async {
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.login(name: name, grade: grade, school: school);
    state = AuthState.authenticated(user);
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AuthState.unauthenticated();
  }
}
