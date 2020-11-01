import 'package:i_account/pages/loginpages/pw_create.dart';
import 'package:i_account/res/colours.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/loginpages/pw_change_auth.dart';
import 'package:i_account/pages/settingspages/darkmode.dart';
import 'package:i_account/pages/settingspages/locksetting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _getPassword(); //获取本地存储的数据
  }

  String _password;

  void _getPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _password = sharedPreferences.get('password') ?? '';
    });
  }

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '设置',
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
      height: 440.0,
      child: Card(
        elevation: 1.0, //设置阴影
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1.0))), //设置圆角
        child: Column(
          children: [
            ListTile(
              title: Text('密码', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('修改文字密码和图形密码'),
              leading: Icon(
                Icons.track_changes,
                color: Colors.blue[500],
              ),
              onTap: () {
                _password == ''
                    ? showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("提示"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("没有设置密码，请先设置密码！")
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>PwcreatePage()));
                          },
                          child: Text("确定"),
                        ),
                      ],
                    );
                  },
                ).then((val) {
                  print(val);
                })
                    : Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PwcauthPage()));
              },
            ),
            Divider(),
            ListTile(
              title:
              Text('深色模式', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('选择深色模式/浅色模式或跟随系统设置'),
              leading: Icon(
                Icons.nights_stay,
                color: Colors.blue[500],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DarkmodePage()));
              },
            ),
            Divider(),
            ListTile(
              title:
              Text('验证设置', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('选择应用启动时是否需要密码'),
              leading: Icon(
                Icons.lock,
                color: Colors.blue[500],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LocksettingPage()));
              },
            ),
            Divider(),
            ListTile(
              title:
              Text('数据导出', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('备份应用数据'),
              leading: Icon(
                Icons.ios_share,
                color: Colors.blue[500],
              ),
              onTap: () {
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("提示"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[Text("已导出应用数据")],
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
              },
            ),
            Divider(),
            ListTile(
              title:
              Text('清除缓存', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('清除应用缓存'),
              leading: Icon(
                Icons.delete,
                color: Colors.blue[500],
              ),
              onTap: () {
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("提示"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[Text("已清空应用缓存")],
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
              },
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
      ),
      body: card,
    );
  }
}
