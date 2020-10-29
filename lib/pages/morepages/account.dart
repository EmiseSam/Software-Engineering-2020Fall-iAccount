import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/pages/accountpages/account_create.dart';
import 'package:i_account/router_jump.dart';
import 'package:i_account/pages/accountpages/bill_search_account.dart';
import 'package:i_account/res/styles.dart';
import 'package:i_account/db/db_helper_account.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List accountnameItemsAssets = new List();
  List accountamountItemsAssets = new List();

  List accountnameItemsDebits = new List();
  List accountamountItemsDebits = new List();

  TextStyle _bannerText = TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  );
  TextStyle _accountTitleStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.black,
  );

  // 总资产
  double totalAssets;

  // 总负债
  double totalLiabilities;

  Future<List> _loadAccountNamesAssets() async {
    List list = await dbAccount.getAccounts(0);
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.account);
    });
    print(accountnameItemsAssets.length);
    return listTemp;
  }

  Future<List> _loadAccountNamesDebits() async {
    List list = await dbAccount.getAccounts(1);
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.account);
    });
    print(accountnameItemsDebits.length);
    return listTemp;
  }

  Future<List> _loadAccountAmountAssets() async {
    List list = await dbAccount.getAccounts(0);
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.balance.toString());
    });
    return listTemp;
  }

  Future<List> _loadAccountAmountDebits() async {
    List list = await dbAccount.getAccounts(1);
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.balance.toString());
    });
    return listTemp;
  }

  //计算总资产
  Future<double> _loadAssets() async {
    double temp = await dbAccount.accountsTotalize(0);
    return temp;
  }

  //计算总资产
  Future<double> _loadDebits() async {
    double temp = await dbAccount.accountsTotalize(1);
    return temp;
  }

  @override
  void initState() {
    _loadAccountNamesAssets().then((value) => setState(() {
      accountnameItemsAssets = value;
    }));
    _loadAccountNamesDebits().then((value) => setState(() {
      accountnameItemsDebits = value;
    }));
    _loadAccountAmountAssets().then((value) => setState(() {
      accountamountItemsAssets = value;
    }));
    _loadAccountAmountDebits().then((value) => setState(() {
      accountamountItemsDebits = value;
    }));
    _loadAssets().then((value) => setState(() {
      totalAssets = value;
    }));
    _loadDebits().then((value) => setState(() {
      totalLiabilities = value;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "账户",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 25.0,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountCreatePage()));
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  bottom: 30.0,
                  left: 10.0,
                  right: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xffF07D59), Color(0xffEB4F70)]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '净资产',
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        text: (totalAssets - totalLiabilities).toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 36.0,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '总资产',
                        style: _bannerText,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          (totalAssets).toStringAsFixed(2),
                          style: _bannerText,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        width: 1.0,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      Text(
                        '总负债',
                        style: _bannerText,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          (totalLiabilities).toStringAsFixed(2),
                          style: _bannerText,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Gaps.vGap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '   资产账户',
                  style: _accountTitleStyle,
                ),
                Text(totalAssets.toStringAsFixed(2),
                    style: _accountTitleStyle),
              ],
            ),
            Gaps.vGap(10),
            Container(
              height: 84 * accountnameItemsAssets.length.toDouble(),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) {
                  return buildListData(context, accountnameItemsAssets[item],
                      accountamountItemsAssets[item]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: (accountnameItemsAssets.length == null)
                    ? 0
                    : accountnameItemsAssets.length,
              ),
            ),
            Gaps.vGap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '   负债账户',
                  style: _accountTitleStyle,
                ),
                Text(totalLiabilities.toStringAsFixed(2),
                    style: _accountTitleStyle),
              ],
            ),
            Gaps.vGap(10),
            Container(
              height: 84 * accountnameItemsDebits.length.toDouble(),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) {
                  return buildListData(context, accountnameItemsDebits[item],
                      accountamountItemsDebits[item]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: (accountnameItemsDebits.length == null)
                    ? 0
                    : accountnameItemsDebits.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListData(
      BuildContext context, String titleItem, String subTitleItem) {
    return new ListTile(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return BillSearchListtAccount(titleItem);
        }));
      },
      onLongPress: () async {
        if(titleItem == '现金'){
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("提示"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("该账户不能删除！")],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text("确定"),
                  ),
                ],
              );
            },
          ).then((val) {
            print(val);
          });
        }else{
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("提示"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("是否删除该账户？")],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text("取消"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouterJump()), ModalRoute.withName('/'));
                      await dbAccount.deleteAccount(titleItem);
                      await dbHelp.deleteAccountBills(titleItem);
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("提示"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[Text("已经删除该账户！")],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                child: Text("确定"),
                              ),
                            ],
                          );
                        },
                      ).then((val) {
                        print(val);
                      });
                    },
                    child: Text("确定"),
                  ),
                ],
              );
            },
          ).then((val) {
            print(val);
          });
        }
      },
      leading: Icon(Icons.account_balance_wallet),
      title: new Text(
        titleItem,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: new Text(
        double.parse(subTitleItem).toStringAsFixed(2)
      ),
      trailing: new Icon(Icons.keyboard_arrow_right),
    );
  }
}