import 'package:i_account/res/colours.dart';
import 'package:i_account/widgets/appbar.dart';

import 'package:i_account/pages/loginpages/pw_change_auth.dart';
import 'package:i_account/pages/settingspages/darkmode.dart';
import 'package:i_account/pages/settingspages/locksetting.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
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
              subtitle: Text('修改密码'),
              leading: Icon(
                Icons.track_changes,
                color: Colors.blue[500],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PwcauthPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('深色模式', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('可自由选择深色模式是否跟随系统设置'),
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
              title: Text('验证设置', style: TextStyle(fontWeight: FontWeight.w500)),
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
              title: Text('更新（TODO）', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('检查是否有新版本'),
              leading: Icon(
                Icons.update,
                color: Colors.blue[500],
              ),
              onTap: () {//todo 这个不急着做，时间不够就砍掉吧
              },
            ),
            Divider(),
            ListTile(
              title: Text('清除缓存（TODO）', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('清除应用缓存'),
              leading: Icon(
                Icons.delete,
                color: Colors.blue[500],
              ),
              onTap: () {//todo 这个不急着做，时间不够就砍掉吧
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
