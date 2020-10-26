import 'package:i_account/db/column.dart';

class Bill extends Object {
  int id;
  double money;
  String bc1;
  String bc2;
  String account;
  String member;
  String time;
  String remark;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMoney: money,
      columnClassification1: bc1,
      columnClassification2: bc2,
      columnAccount: account,
      columnMember: member,
      columnTime: time,
      columnRemark: remark,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Bill(double money, String bc1, String bc2, String time, String account,
      String member,
      [String remark]) {
    this.money = money;
    this.bc1 = bc1;
    this.bc2 = bc2;
    this.time = time;
    this.account = account;
    this.member = member;
    this.remark = remark;
  }

  Bill.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    money = map[columnMoney];
    bc1 = map[columnClassification1];
    bc2 = map[columnClassification2];
    time = map[columnTime];
    account = map[columnAccount];
    member = map[columnMember];
    remark = map[columnRemark];
  }
}
