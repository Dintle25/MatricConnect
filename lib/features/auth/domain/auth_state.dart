import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_state.freezed.dart';

/// A union of every state login can be in. Because Freezed generates
/// a sealed class under the hood, the `when()` below will not even
/// compile if we forget to handle one of these — the compiler
/// catches it instead of a student finding a blank screen.
@freezed
class AuthState with _$AuthState {
  const factory AuthState.unknown() = AuthUnknown;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.authenticated(UserModel user) = AuthAuthenticated;
}
