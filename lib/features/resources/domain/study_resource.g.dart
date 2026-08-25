// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudyResourceImpl _$$StudyResourceImplFromJson(Map<String, dynamic> json) =>
    _$StudyResourceImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      subject: json['subject'] as String,
      grade: json['grade'] as String,
      type: $enumDecode(_$ResourceTypeEnumMap, json['type']),
      fileSizeMb: (json['fileSizeMb'] as num).toDouble(),
      pages: (json['pages'] as num?)?.toInt(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      downloadCount: (json['downloadCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$StudyResourceImplToJson(_$StudyResourceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subject': instance.subject,
      'grade': instance.grade,
      'type': _$ResourceTypeEnumMap[instance.type]!,
      'fileSizeMb': instance.fileSizeMb,
      'pages': instance.pages,
      'durationMinutes': instance.durationMinutes,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'isBookmarked': instance.isBookmarked,
      'downloadCount': instance.downloadCount,
    };

const _$ResourceTypeEnumMap = {
  ResourceType.pastPaper: 'past_paper',
  ResourceType.studyGuide: 'study_guide',
  ResourceType.video: 'video',
  ResourceType.memo: 'memo',
};
