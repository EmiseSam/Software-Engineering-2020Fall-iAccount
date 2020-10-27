<<<<<<< HEAD
import 'package:i_account/db/column.dart';

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
}
=======
import 'package:i_account/db/column.dart';

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
}
>>>>>>> b3e7aa5187f3436cd3947149c919df94585ee660
