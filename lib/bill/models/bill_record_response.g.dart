// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_record_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillRecordModel _$BillRecordModelFromJson(Map<String, dynamic> json) {
  return BillRecordModel(
    json['id'] as int,
    (json['money'] as num)?.toDouble(),
    json['member'] as String,
    json['account'] as String,
    json['remark'] as String,
    json['typeofB'] as int,
    json['classification1'] as String,
    json['classification2'] as String,
    json['project'] as String,
    json['store'] as String,
    json['createTime'] as String,
    json['createTimestamp'] as int,
    json['updateTime'] as String,
    json['updateTimestamp'] as int,
  );
}

Map<String, dynamic> _$BillRecordModelToJson(BillRecordModel instance) =>
    <String, dynamic>{
      columnId: instance.id,
      columnMoney: instance.money,
      columnMember: instance.member,
      columnAccount: instance.account,
      columnRemark: instance.remark,
      columntypeofB: instance.typeofB,
      columnClassification1: instance.classification1,
      columnClassification2: instance.classification2,
      columnProject: instance.project,
      columnStore: instance.store,
      columnCreateTime: instance.createTime,
      columnCreateTimestamp: instance.createTimestamp,
      columnUpdateTime: instance.updateTime,
      columnUpdateTimestamp: instance.updateTimestamp
    };
