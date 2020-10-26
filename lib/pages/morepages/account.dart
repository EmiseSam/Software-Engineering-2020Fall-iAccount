import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:i_account/pages/accountpages/account_create.dart';
import 'package:i_account/routers/fluro_navigator.dart';
import 'package:i_account/res/styles.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<String> accountnameItemsAssets = <String>[
    'keyboard',
    'print',
    'keyboard',
    'keyboard',
    'keyboard',
    'keyboard',
  ];
  List<String> accountamountItemsAssets = <String>[
    'keyboard',
    'print',
    'keyboard',
    'keyboard',
    'keyboard',
    'keyboard',
  ];
  List<String> accountnameItemsDebits = <String>[
    'keyboard',
    'print',
  ];
  List<String> accountamountItemsDebits = <String>[
    'keyboard',
    'print',
  ];

  String name;
  String amount;

  TextStyle _bannerText = TextStyle(fontSize: 14.0, color: Colors.white);
  TextStyle _accountTitleStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.black45,
  );

  // 总资产
  num totalAssets = 0.00;

  // 总负债
  num totalLiabilities = 0.00;

  @override
  void initState() {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountCreateAssetsPage()));
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
                        text: ((totalAssets - totalLiabilities).toInt() ?? 0)
                            .toString(),
                        style: TextStyle(
                          fontSize: 36.0,
                        ),
                        children: [
                          TextSpan(text: '.', style: TextStyle(fontSize: 20.0)),
                          TextSpan(
                            text: (int.tryParse((totalAssets - totalLiabilities)
                                    .toStringAsFixed(2)
                                    .split('.')[1]))
                                .toString(),
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
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
                          (totalAssets.toInt()).toStringAsFixed(2),
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
                          (totalLiabilities.toInt()).toStringAsFixed(2),
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
                Text(totalAssets.toInt().toStringAsFixed(2),
                    style: _accountTitleStyle),
              ],
            ),
            Gaps.vGap(10),
            Container(
              height: 84*accountnameItemsAssets.length.toDouble(),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, item) {
                    return buildListData(context, accountnameItemsAssets[item],
                        accountamountItemsAssets[item]);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: accountnameItemsAssets.length),
            ),
            Gaps.vGap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '   负债账户',
                  style: _accountTitleStyle,
                ),
                Text(totalLiabilities.toInt().toStringAsFixed(2),
                    style: _accountTitleStyle),
              ],
            ),
            Gaps.vGap(10),
            Container(
              height: 84*accountnameItemsDebits.length.toDouble(),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, item) {
                    return buildListData(context, accountnameItemsDebits[item],
                        accountamountItemsDebits[item]);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: accountnameItemsDebits.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListData(
      BuildContext context, String titleItem, String subTitleItem) {
    return new ListTile(
      leading: Icon(Icons.account_balance_wallet),
      title: new Text(
        titleItem,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: new Text(
        subTitleItem,
      ),
      trailing: new Icon(Icons.keyboard_arrow_right),
      onTap: () {},
    );
  }
}
