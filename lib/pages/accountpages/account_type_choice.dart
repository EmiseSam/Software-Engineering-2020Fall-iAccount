import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/accountpages/model/accounttemplate.dart';
import 'package:i_account/pages/accountpages/account_create_final.dart';


class AccounttypechoicePage extends StatefulWidget {
  @override
  _AccounttypechoicePageState createState() => _AccounttypechoicePageState();
}

class _AccounttypechoicePageState extends State<AccounttypechoicePage> {

  String name;
  String amount;

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '选择账户类型',
          style: TextStyle(
              fontSize: 18,
              color: Colours.app_main,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> items = List<Widget>();
    items.add(generateAccountTypeTitle("资产账户"));
    items.addAll(ASSETS_ACCOUNT_TEMPLATES.map((e) => generateAccountTemplate(e)).toList());
    items.add(generateAccountTypeTitle("负债账户"));
    items.addAll(LIABILITIES_ACCOUNT_TEMPLATES.map((e) => generateAccountTemplate(e)).toList());

    Widget divider = Divider(color: Colors.grey, height: 1,);
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
      ),
      body: ListView.separated(
        itemCount: items.length,
        //列表项构造器
        itemBuilder: (BuildContext context, int index) {
          return items[index];
        },
        //分割器构造器
        separatorBuilder: (BuildContext context, int index) {
          if(index == 0 ||
              index == ASSETS_ACCOUNT_TEMPLATES.length ||
              index == ASSETS_ACCOUNT_TEMPLATES.length + 1 ||
              index == ASSETS_ACCOUNT_TEMPLATES.length + LIABILITIES_ACCOUNT_TEMPLATES.length + 1) {
            return Divider(color: Colors.transparent, height: 0);
          } else {
            return divider;
          }
        },
      ),
    );
  }
  Widget generateAccountTypeTitle(String title) {
    return Container(
      height: 48,
      color: Color(0xFFF0F0F0),
      padding: EdgeInsets.only(left: 16, right: 16),
      alignment: Alignment.centerLeft,
      child: Text(title),
    );
  }

  Widget generateAccountTemplate(AccountTemplate accountTemplate) {
    List<Widget> title = [Text(accountTemplate.name, textScaleFactor: 1.0,)];
    if(null != accountTemplate.desc) {
      title.add(Text(accountTemplate.desc,
        textScaleFactor: 0.8,
        style: TextStyle(color: Colors.grey),
      ));
    }
    return GestureDetector(
      onTap: () {Navigator.push(context,
          MaterialPageRoute(builder: (context) => AccountCFPage()));
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        width: double.infinity,
        height: 56,
        child: Row(
          children: [
            Icon(Icons.album),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: title,
              ),
            )
          ],
        ),
      ),
    );
  }

}