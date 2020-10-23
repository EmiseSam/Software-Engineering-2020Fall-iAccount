import 'package:flutter/material.dart';
import 'package:i_account/pages/loginpages/pw_change_auth_pattern.dart';
import 'package:i_account/pages/loginpages/pw_change.dart';
import 'package:i_account/res/colours.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PwcauthPage extends StatefulWidget {
  PwcauthPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PwcauthPageState createState() => _PwcauthPageState();
}

class _PwcauthPageState extends State<PwcauthPage> {
  final _userPwd = TextEditingController(); //密码
  GlobalKey _globalKey = new GlobalKey<FormState>(); //用于检查输入框是否为空

  String _password;

  @override
  void initState() {
    super.initState();
    _getPassword();//获取本地存储的数据
  }

  void _getPassword() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      _password = sharedPreferences.get('password') ?? '';
    });
  }

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

  ///用于控制指纹按钮的隐藏和显示
  bool _fingerprintSet = true;

  /// 本地认证框架
  final LocalAuthentication auth = LocalAuthentication();

  /// 检查是否有可用的生物识别技术
  Future<Null> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    if (!canCheckBiometrics) {
      _fingerprintSet = false;
    }
  }

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
        return PwchangePage();
      }), (route) => route == null);
    }
  }

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '修改密码',
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
                              if (_userPwd.text == _password) {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return PwchangePage();
                                }), (route) => route == null);
                              } else{
                                showDialog<Null>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("提示"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[Text("密码错误")],
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
                            }
                          },
                          shape: StadiumBorder(side: BorderSide()),
                          child: Text(
                            "下一步",
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
            )));
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
                                  builder: (context) => PwcauthpatternPage()));
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
          '其他验证方式',
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
        '验证密码以进行下一步',
        style: TextStyle(fontSize: 32.0),
      ),
    );
  }
}
