import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/loginpages/pw_change.dart';
import 'package:i_account/pages/loginpages/pw_change_auth_set.dart';

class LocksettingPage extends StatefulWidget {
  @override
  _LocksettingPageState createState() => _LocksettingPageState();
}

class _LocksettingPageState extends State<LocksettingPage> {
  bool hasPW = true;

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '验证设置',
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
    return Scaffold(
        appBar: MyAppBar(
          titleWidget: _buildAppBarTitle(),
        ),
        body: Center(
            child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              title: Text("启用密码"),
              onTap: () {
                if (hasPW) {
                  //TODO 修改数据库让首页跳转到登录页面
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("提示"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[Text("已启用密码")],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PwchangePage()));
                }
              },
            ),
            ListTile(
              title: Text("关闭密码"),
              onTap: () {
                if (hasPW) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PwcauthsecPage()));
                } else {
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("提示"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[Text("您没有设置密码，无需关闭")],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
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
                }
              },
            ),
          ]).toList(),
        )));
  }
}
