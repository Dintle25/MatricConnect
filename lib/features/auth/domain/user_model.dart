import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// A logged-in student. Freezed gives us copyWith, ==, hashCode, and
/// toString for free, so we never write "did I forget a field in
/// copyWith again" bugs.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String grade,
    required String school,
    @Default(0) int resourcesDownloaded,
    @Default(false) bool isTutor,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
