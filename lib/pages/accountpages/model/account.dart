import 'package:i_account/pages/accountpages/model/accounttype.dart';

class Account {
  Account({this.name = "现金", this.desc = "现金余额", this.balance = 0.0});

  int id;
  String uuid;
  String name = "现金";
  String desc = "现金余额";
  bool isDeleted;
  AccountType type;
  int orderIndex;
  double balance = 0.0;
  int dueDay;
  int billDay;
  double creditLimit;
  String background;
  String icon;
  int mTime;
  String deviceId;
}
