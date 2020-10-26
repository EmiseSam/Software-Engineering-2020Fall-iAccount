import 'package:i_account/db/column.dart';
import 'column.dart';

class AccountClassification extends Object {
  int id;
  String account;
  double sum;
  double balance;
  int typeofA;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAccount: account,
      columnMoney: sum,
      columnBalance: balance,
      columntypeofA: typeofA
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  AccountClassification(String account, int typeofA,
      {int id, double sum = 0.00, double balance = 0.00}) {
    this.id = id;
    this.account = account;
    this.sum = sum;
    this.balance = balance;
    this.typeofA = typeofA;
  }

  AccountClassification.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    account = map[columnAccount];
    sum = map[columnMoney];
    balance = map[columnBalance];
    typeofA = map[columntypeofA];
  }
}
