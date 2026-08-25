import '../../../core/storage/secure_storage_service.dart';
import '../domain/user_model.dart';

/// Handles logging in and remembering who's logged in. There's no
/// real backend for this demo, so login just checks the name isn't
/// empty and hands back a fake student — but the token is still
/// saved for real, through flutter_secure_storage.
class AuthRepository {
  final SecureStorageService _storage;

  AuthRepository(this._storage);

  Future<UserModel> login({required String name, required String grade, required String school}) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final fakeToken = 'demo-token-${DateTime.now().millisecondsSinceEpoch}';
    await _storage.saveToken(fakeToken);
    await _storage.saveUserId(name.toLowerCase().replaceAll(' ', '-'));

    return UserModel(
      id: name.toLowerCase().replaceAll(' ', '-'),
      name: name,
      grade: grade,
      school: school,
    );
  }

  Future<void> logout() => _storage.clear();

  Future<bool> get isLoggedIn => _storage.hasToken;
}
