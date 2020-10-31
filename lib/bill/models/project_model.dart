import 'package:i_account/db/column.dart';
import 'package:json_annotation/json_annotation.dart';
part 'project_model.g.dart';

@JsonSerializable()
class Project extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'project')
  String project;

  Project(String project, {int id}) {
    this.id = id;
    this.project = project;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnProject: project};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Project.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    project = map[columnProject];
  }
  factory Project.fromJson(Map<String, dynamic> srcJson) =>
      _$ProjectFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
