import 'package:i_account/db/column.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class Member extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'member')
  String member;

  Member(String member, {int id}) {
    this.id = id;
    this.member = member;
  }

  Member.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    member = map[columnMember];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMember: member,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  factory Member.fromJson(Map<String, dynamic> srcJson) =>
      _$MemberFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
