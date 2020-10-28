/// 组头
class BillRecordGroup {
  BillRecordGroup(this.date, this.expenMoney, this.incomeMoney) : super();

  /// 日期
  String date;

  /// 当天总支出金额
  double expenMoney;

  /// 当日总收入
  double incomeMoney;
}

/// 月份记录
class BillRecordMonth {
  BillRecordMonth(this.expenMoney, this.incomeMoney, this.recordLsit)
      : super();

  /// 当月总支出金额
  double expenMoney;

  /// 当月总收入
  double incomeMoney;

  /// 账单记录
  List recordLsit;
}
