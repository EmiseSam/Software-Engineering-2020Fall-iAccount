import 'package:i_account/db/column.dart';
part 'member_model.g.dart';

class Member extends Object {
  int id;
  String member;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMember: member,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Member(String member, [int id]) {
    this.id = id;
    this.member = member;
  }

  Member.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    member = map[columnMember];
  }
  factory Member.fromJson(Map<String, dynamic> srcJson) =>
      _$MemberFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
