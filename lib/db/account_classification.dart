import 'package:i_account/db/column.dart';

class AccountClassification extends Object {
  int id;
  String account;
  double sum;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnAccount: account, columnMoney: sum};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  AccountClassification(String account, [double sum = 0.00]) {
    this.account = account;
    this.sum = sum;
  }

  AccountClassification.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    account = map[columnAccount];
    sum = map[columnMoney];
  }
}
