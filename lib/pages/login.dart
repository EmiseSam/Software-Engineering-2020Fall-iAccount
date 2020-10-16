import 'package:flutter/material.dart';
import 'package:i_account/pages/tabs.dart';
import 'package:i_account/pages/loginpages/patternlock.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userPwd = TextEditingController(); //密码
  GlobalKey _globalKey = new GlobalKey<FormState>(); //用于检查输入框是否为空

  final _formKey = GlobalKey<FormState>();
  List _loginMethod = [
    {
      "title": "指纹",
      "icon": Icons.fingerprint,
    },
    {
      "title": "手势",
      "icon": Icons.select_all,
    },
  ];

  /// 本地认证框架
  final LocalAuthentication auth = LocalAuthentication();

  /// 生物识别
  Future<Null> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: '扫描指纹进行身份验证',
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    if (authenticated) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Tabs();
      }), (route) => route == null);
    }
  }

  void _login() {
    showDialog(
        context: context,
        builder: (context) {
          if (_userPwd.text != "123456") {
            return AlertDialog(
              title: Text('提示'),
              content: Text("密码错误，请重新输入"),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 70.0),
                SizedBox(height: 30.0),
                Form(
                  key: _globalKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _userPwd,
                        decoration: InputDecoration(
                          labelText: '密码',
                          hintText: '请输入你的密码',
                          icon: Icon(Icons.lock),
                        ),
                        validator: (v) {
                          return v.trim().length > 5 ? null : "密码不能低于6位";
                        },
                        obscureText: true,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      SizedBox(
                        height: 45.0,
                        width: 270.0,
                        child: RaisedButton(
                          onPressed: () {
                            if ((_globalKey.currentState as FormState)
                                .validate()) {
                              _login();
                              if (_userPwd.text == "123456") {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return Tabs();
                                }), (route) => route == null);
                              }
                            }
                          },
                          shape: StadiumBorder(side: BorderSide()),
                          child: Text(
                            "登录",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline5, //字体白色
                          ),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 90.0),
                buildOtherLoginText(),
                buildOtherMethod(context),
              ],
            )
        )
    );
  }

  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
                builder: (context) {
                  return IconButton(
                      icon: Icon(
                        item['icon'],
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        if (item['title'] == '指纹') {
                          _authenticate();
                        } else if (item['title'] == '手势') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatternlockPage()));
                        }
                      });
                },
              ))
          .toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他登录方式',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '欢迎使用iAccount',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
}
