// GENERATED CODE - DO NOT MODIFY BY HAND\
part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
AccountClassification _$AccountClassificationFromJson(
    Map<String, dynamic> json) {
  return AccountClassification(
      json['account'] as String, json['typeofA'] as int,
      id: json['id'] as int,
      sum: (json['sum'] as num)?.toDouble(),
      balance: (json['balance'] as num)?.toDouble());
}

Map<String, dynamic> _$AccountClassificationToJson(
        AccountClassification instance) =>
    <String, dynamic>{
      columnId: instance.id,
      columnAccount: instance.account,
      columnMoney: instance.sum,
      columnBalance: instance.balance,
      columntypeofA: instance.typeofA
    };
