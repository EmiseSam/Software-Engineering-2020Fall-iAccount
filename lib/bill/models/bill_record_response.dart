import 'package:json_annotation/json_annotation.dart';
import 'package:i_account/db/column.dart';
part 'bill_record_response.g.dart';

@JsonSerializable()
class BillRecordModel extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'money')
  double money;

  @JsonKey(name: 'member')
  String member;

  @JsonKey(name: 'account')
  String account;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'classification1')
  String classification1;

  @JsonKey(name: 'classification2')
  String classification2;

  /// 类型 1支出 2收入
  @JsonKey(name: 'typeofB')
  int typeofB;

  @JsonKey(name: 'project')
  String project;

  @JsonKey(name: 'store')
  String store;

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
    this.member,
    this.account,
    this.remark,
    this.typeofB,
    this.classification1,
    this.classification2,
    this.project,
    this.store,
    this.createTime,
    this.createTimestamp,
    this.updateTime,
    this.updateTimestamp,
  );

  BillRecordModel.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    money = map[columnMoney];
    member = map[columnMember];
    account = map[columnAccount];
    remark = map[columnRemark];
    typeofB = map[columntypeofB];
    classification1 = map[columnClassification1];
    classification2 = map[columnClassification2];
    project = map[columnProject];
    store = map[columnStore];
    createTime = map[columnCreateTime];
    createTimestamp = map[columnCreateTimestamp];
    updateTime = map[columnUpdateTime];
    updateTimestamp = map[columnUpdateTimestamp];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMoney: money,
      columnMember: member,
      columnAccount: account,
      columnRemark: remark,
      columntypeofB: typeofB,
      columnClassification1: classification1,
      columnClassification2: classification2,
      columnProject: project,
      columnStore: store,
      columnCreateTime: createTime,
      columnCreateTimestamp: createTimestamp,
      columnUpdateTime: updateTime,
      columnUpdateTimestamp: updateTimestamp
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  factory BillRecordModel.fromJson(Map<String, dynamic> srcJson) =>
      _$BillRecordModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BillRecordModelToJson(this);
}
