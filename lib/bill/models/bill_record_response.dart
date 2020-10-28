import 'package:json_annotation/json_annotation.dart';

part 'bill_record_response.g.dart';

@JsonSerializable()
class BillRecordModel extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'money')
  double money;

  @JsonKey(name: 'person')
  String person;

  @JsonKey(name: 'account')
  String account;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'categoryName')
  String categoryName;

  /// 类型 1支出 2收入
  @JsonKey(name: 'type')
  int type;

  /// 是否已同步
  @JsonKey(name: 'isSync')
  int isSync;

  /// 是否已删除
  @JsonKey(name: 'isDelete')
  int isDelete;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'createTimestamp')
  int createTimestamp;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'updateTimestamp')
  int updateTimestamp;

  BillRecordModel(
    this.id,
    this.money,
    this.person,
    this.account,
    this.remark,
    this.type,
    this.categoryName,
    this.createTime,
    this.createTimestamp,
    this.updateTime,
    this.updateTimestamp,
  );

  factory BillRecordModel.fromJson(Map<String, dynamic> srcJson) =>
      _$BillRecordModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BillRecordModelToJson(this);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'person': person,
      'account': account,
      'remark': remark,
      'categoryName': categoryName,
      'createTime': createTime,
      'updateTime': updateTime,
      'money': money,
      'type': type,
      'isSync': isSync,
      'createTimestamp': createTimestamp,
      'updateTimestamp': updateTimestamp
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  BillRecordModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    money = map['money'];
    person = map['person'];
    account = map['account'];
    remark = map['remark'];
    type = map['type'];
    categoryName = map['categoryName'];
    createTime = map['createTime'];
    createTimestamp = map['createTimestamp'];
    updateTime = map['updateTime'];
    updateTimestamp = map['updateTimestamp'];
  }
}
