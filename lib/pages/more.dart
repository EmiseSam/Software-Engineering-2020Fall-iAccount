import 'package:i_account/res/colours.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/morepages/about.dart';
import 'package:i_account/pages/morepages/settings.dart';
import 'package:i_account/pages/morepages/account.dart';
import 'package:i_account/pages/morepages/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> with TickerProviderStateMixin {
  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          'iAccount',
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
    var card = SizedBox(
      height: 352.0,
      child: Card(
        elevation: 1.0, //设置阴影
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1.0))), //设置圆角
        child: Column(
          children: [
            ListTile(
              title: Text('资产', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('账户信息管理'),
              leading: Icon(
                Icons.account_balance_wallet,
                color: Colors.blue[500],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccountPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('图表', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('使用图表分析消费情况'),
              leading: Icon(
                Icons.pie_chart,
                color: Colors.blue[500],
              ),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChartPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('设置', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('修改密码、软件设置'),
              leading: Icon(
                Icons.settings,
                color: Colors.blue[500],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('关于', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('开发者信息'),
              leading: Icon(
                Icons.laptop_windows,
                color: Colors.blue[500],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
              },
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
        isBack: false,
      ),
      body: card,
    );
  }
}
