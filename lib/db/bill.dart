import 'package:i_account/db/column.dart';

class Bill extends Object {
  int id;
  double money;
  String remark;
  String bc1;
  String bc2;
  String icon;
  String account;
  String member;
  String time;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMoney: money,
      columnRemark: remark,
      columnClassification1: bc1,
      columnClassification2: bc2,
      columnIcon: icon,
      columnAccount: account,
      columnMember: member,
      columnTime: time
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Bill(double money, String bc1, String bc2, String time,
      [String remark, String icon, String account = '', String member = '']) {
        
      }
}
