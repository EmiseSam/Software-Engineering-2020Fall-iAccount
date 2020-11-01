import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/pages/accountpages/account_create.dart';
import 'package:i_account/router_jump.dart';
import 'package:i_account/pages/accountpages/bill_search_account.dart';
import 'package:i_account/res/styles.dart';
import 'package:i_account/widgets/input_textview_dialog_account.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List accountNameAssets = new List();
  List accountAmountAssets = new List();

  List accountNameDebits = new List();
  List accountAmountDebits = new List();

  TextStyle _bannerText = TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  );
  TextStyle _accountTitleStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.black,
  );

  // 总资产
  double totalAssets = 0.00;

  // 总负债
  double totalLiabilities = 0.00;

  Future<List> _loadAccountNamesAssets() async {
    List list = await dbHelp.getAccounts(0);
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.account);
    });
    return listTemp;
  }

  Future<List> _loadAccountNamesDebits() async {
    List list = await dbHelp.getAccounts(1);
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.account);
    });
    return listTemp;
  }

  Future<List> _loadAccountAmountAssets() async {
    List list = await dbHelp.getAccounts(0);
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.balance.toString());
    });
    return listTemp;
  }

  Future<List> _loadAccountAmountDebits() async {
    List list = await dbHelp.getAccounts(1);
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.balance.toString());
    });
    return listTemp;
  }

  //计算总资产
  Future<double> _loadAssets() async {
    double temp = await dbHelp.accountsTotalize(0);
    return temp;
  }

  //计算总资产
  Future<double> _loadDebits() async {
    double temp = await dbHelp.accountsTotalize(1);
    return temp;
  }

  @override
  void initState() {
    _loadAssets().then((value) => setState(() {
          totalAssets = value;
        }));
    _loadDebits().then((value) => setState(() {
          totalLiabilities = value;
        }));
    _loadAccountNamesAssets().then((value) => setState(() {
          accountNameAssets = value;
        }));
    _loadAccountNamesDebits().then((value) => setState(() {
          accountNameDebits = value;
        }));
    _loadAccountAmountAssets().then((value) => setState(() {
          accountAmountAssets = value;
        }));
    _loadAccountAmountDebits().then((value) => setState(() {
          accountAmountDebits = value;
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
                        text:
                            (totalAssets + totalLiabilities).toStringAsFixed(2),
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
                Text(totalAssets.toStringAsFixed(2), style: _accountTitleStyle),
              ],
            ),
            Gaps.vGap(10),
            Container(
              height: 84 * accountNameAssets.length.toDouble() ?? 0.00,
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) {
                  return buildListData(context, accountNameAssets[item],
                      accountAmountAssets[item]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: accountNameAssets.length ?? 0,
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
              height: 84 * accountNameDebits.length.toDouble() ?? 0.00,
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) {
                  return buildListData(context, accountNameDebits[item],
                      accountAmountDebits[item]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: accountNameDebits.length ?? 0,
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
        if (titleItem == '现金') {
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("提示"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("该账户不能删除或编辑！")],
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
        } else {
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("提示"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("是否删除该账户？\n\n删除账户的同时也会删除相应的流水信息。")],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text("取消"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return TextViewDialogAccount(
                              confirm: (text) async {
                                var tempAccount =
                                    await dbHelp.getAccount(titleItem);
                                await dbHelp.updateAccountBills(
                                    tempAccount, text);
                                tempAccount.account = text;
                                await dbHelp.insertAccount(tempAccount);
                              },
                            );
                          });
                    },
                    child: Text("编辑"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => RouterJump()),
                          ModalRoute.withName('/'));
                      await dbHelp.deleteAccount(titleItem);
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
      subtitle: new Text(double.parse(subTitleItem).toStringAsFixed(2)),
      trailing: new Icon(Icons.keyboard_arrow_right),
    );
  }
}
