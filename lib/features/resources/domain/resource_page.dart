import 'package:freezed_annotation/freezed_annotation.dart';
import 'study_resource.dart';

part 'resource_page.freezed.dart';

/// One "page" of results from the resources list, plus whether
/// there's more to load. Keeping this separate from a plain
/// List<StudyResource> means the pagination provider always knows
/// whether to show a "loading more..." spinner at the bottom.
@freezed
class ResourcePage with _$ResourcePage {
  const factory ResourcePage({
    required List<StudyResource> items,
    required int page,
    required bool hasMore,
  }) = _ResourcePage;
}
