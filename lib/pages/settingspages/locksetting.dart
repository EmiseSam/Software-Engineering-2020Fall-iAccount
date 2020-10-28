import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:i_account/pages/loginpages/pw_create.dart';

class LocksettingPage extends StatefulWidget {
  @override
  _LocksettingPageState createState() => _LocksettingPageState();
}

class _LocksettingPageState extends State<LocksettingPage> {
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

  void _lockOn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("lockset", true);
  }

  void _lockOff() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("lockset", false);
  }

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
                _lockOn();
                if (_password == '') {
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("提示"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[Text("已启用密码，请进行密码设置")],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return PwcreatePage();
                              }), (route) => route == null);
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
                }
              },
            ),
            ListTile(
                title: Text("关闭密码"),
                onTap: () {
                  _lockOff();
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("提示"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[Text("已关闭密码")],
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
                }),
          ]).toList(),
        ),
      ),
    );
  }
}
