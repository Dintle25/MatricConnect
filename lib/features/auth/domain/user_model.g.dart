// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      grade: json['grade'] as String,
      school: json['school'] as String,
      resourcesDownloaded: (json['resourcesDownloaded'] as num?)?.toInt() ?? 0,
      isTutor: json['isTutor'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'grade': instance.grade,
      'school': instance.school,
      'resourcesDownloaded': instance.resourcesDownloaded,
      'isTutor': instance.isTutor,
    };
