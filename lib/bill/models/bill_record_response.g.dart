// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_record_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillRecordModel _$BillRecordModelFromJson(Map<String, dynamic> json) {
  return BillRecordModel(
    json['id'] as int,
    (json['money'] as num)?.toDouble(),
    json['person'] as String,
    json['account'] as String,
    json['remark'] as String,
    json['type'] as int,
    json['categoryName'] as String,
    json['createTime'] as String,
    json['createTimestamp'] as int,
    json['updateTime'] as String,
    json['updateTimestamp'] as int,
  )
    ..isSync = json['isSync'] as int
    ..isDelete = json['isDelete'] as int;
}

Map<String, dynamic> _$BillRecordModelToJson(BillRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'money': instance.money,
      'person': instance.person,
      'account': instance.account,
      'remark': instance.remark,
      'categoryName': instance.categoryName,
      'type': instance.type,
      'isSync': instance.isSync,
      'isDelete': instance.isDelete,
      'createTime': instance.createTime,
      'createTimestamp': instance.createTimestamp,
      'updateTime': instance.updateTime,
      'updateTimestamp': instance.updateTimestamp,
    };
