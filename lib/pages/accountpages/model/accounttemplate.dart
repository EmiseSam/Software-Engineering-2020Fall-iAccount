import 'package:i_account/pages/accountpages/model/accounttype.dart';

class AccountTemplate {
  const AccountTemplate(this.accountType, this.name, {this.desc = null});

  final AccountType accountType;
  final String name;
  final String desc;

}

const List<AccountTemplate> ASSETS_ACCOUNT_TEMPLATES = <AccountTemplate>[
  AccountTemplate(AccountType.assets, "现金"),
  AccountTemplate(AccountType.assets, "银联卡"),
  AccountTemplate(AccountType.assets, "支付宝"),
  AccountTemplate(AccountType.assets, "微信"),
];
const List<AccountTemplate> LIABILITIES_ACCOUNT_TEMPLATES = <AccountTemplate>[
  AccountTemplate(AccountType.liabilities, "信用卡"),
  AccountTemplate(AccountType.liabilities, "花呗"),
  AccountTemplate(AccountType.liabilities, "京东白条"),
];
