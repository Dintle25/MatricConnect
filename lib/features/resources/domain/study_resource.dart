import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_resource.freezed.dart';
part 'study_resource.g.dart';

/// The type of resource, kept as an enum so the UI can switch on it
/// with a compiler-checked switch instead of comparing raw strings
/// like "pastpaper" vs "past_paper" and hoping we spelled it right.
enum ResourceType {
  @JsonValue('past_paper')
  pastPaper,
  @JsonValue('study_guide')
  studyGuide,
  @JsonValue('video')
  video,
  @JsonValue('memo')
  memo,
}

/// One downloadable item — a past paper, a study guide, a memo, or a
/// short video. Freezed generates copyWith (handy for toggling
/// isBookmarked without rebuilding the whole object by hand) plus
/// JSON parsing for talking to a real backend later.
@freezed
class StudyResource with _$StudyResource {
  const StudyResource._();

  const factory StudyResource({
    required String id,
    required String title,
    required String subject,
    required String grade,
    required ResourceType type,
    required double fileSizeMb,
    int? pages,
    int? durationMinutes,
    required DateTime uploadedAt,
    @Default(false) bool isBookmarked,
    @Default(0) int downloadCount,
  }) = _StudyResource;

  factory StudyResource.fromJson(Map<String, dynamic> json) => _$StudyResourceFromJson(json);

  /// Small helper so widgets don't need their own switch statement
  /// just to pick an icon.
  String get typeLabel => switch (type) {
        ResourceType.pastPaper => 'Past Paper',
        ResourceType.studyGuide => 'Study Guide',
        ResourceType.video => 'Video',
        ResourceType.memo => 'Memo',
      };
}
