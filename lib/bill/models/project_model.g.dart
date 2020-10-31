// GENERATED CODE - DO NOT MODIFY BY HAND\
part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project(json['project'] as String, id: json['id'] as int);
}

Map<String, dynamic> _$ProjectToJson(Project instance) =>
    <String, dynamic>{columnId: instance.id, columnProject: instance.project};
