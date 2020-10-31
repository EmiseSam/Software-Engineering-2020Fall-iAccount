import 'package:i_account/db/column.dart';
import 'package:json_annotation/json_annotation.dart';
part 'account_model.g.dart';

@JsonSerializable()
class AccountClassification extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'account')
  String account;

  @JsonKey(name: 'sum')
  double sum;

  @JsonKey(name: 'balance')
  double balance;

  @JsonKey(name: 'typeofA')
  int typeofA;

  AccountClassification(String account, int typeofA,
      {int id, double sum = 0.00, double balance = 0.00}) {
    this.id = id;
    this.account = account;
    this.sum = sum;
    this.balance = balance;
    this.typeofA = typeofA;
  }

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

  AccountClassification.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    account = map[columnAccount];
    sum = map[columnMoney];
    balance = map[columnBalance];
    typeofA = map[columntypeofA];
  }
  factory AccountClassification.fromJson(Map<String, dynamic> srcJson) =>
      _$AccountClassificationFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccountClassificationToJson(this);
}
