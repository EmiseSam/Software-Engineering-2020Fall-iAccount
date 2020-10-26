import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/routers/fluro_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:i_account/pages/loginpages/patternlock-create.dart';

class PwcreatePage extends StatefulWidget {
  @override
  _PwcreatePageState createState() => _PwcreatePageState();
}

class _PwcreatePageState extends State<PwcreatePage> {
  String pw1;
  String pw2;
  String _pw_origin;

  @override
  void initState() {
    super.initState();
    _getOriginPW();//获取本地存储的数据
  }

  void _createPassword(value) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences.setString("password", value);
  }

  void _getOriginPW()  async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      _pw_origin = sharedPreferences.get('password') ?? '';
    });
  }


  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '修改/创建密码',
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
          isBack: false,
        ),
        resizeToAvoidBottomInset: false,
        body: Form(
            //key: _formKey,
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            buildTitle(),
            //buildTitleLine(),
            SizedBox(height: 100.0),
            Form(
              //key: _globalKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    //controller: _userPwd,
                    decoration: InputDecoration(
                      labelText: '密码',
                      hintText: '请输入你的密码',
                      icon: Icon(Icons.lock),
                    ),
                    validator: (v) {
                      pw1 = v.trim();
                      return v.trim().length > 5 ? null : "密码不能低于6位";
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 50.0),
                  TextFormField(
                    //controller: _userPwd,
                    decoration: InputDecoration(
                      labelText: '重复输入密码',
                      hintText: '请再次输入你的密码',
                      icon: Icon(Icons.lock),
                    ),
                    validator: (v) {
                      pw2 = v.trim();
                      return v.trim().length > 5
                          ? pw1 == pw2
                              ? null
                              : "与第一次输入的密码不相同"
                          : "密码不能低于6位";
                    },
                    obscureText: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                  ),
                  SizedBox(
                    height: 45.0,
                    width: 270.0,
                    child: FlatButton(
                      onPressed: () {
                        if (pw1 != pw2){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('提示'),
                                  content: Text('两次密码不一致，请重新输入'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        NavigatorUtils.goBack(context);
                                      },
                                      child: Text('确定'),
                                    ),
                                  ],
                                );
                              });
                        } else if (pw1.length < 6 || pw2.length < 6){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('提示'),
                                  content: Text('密码不能小于6位，请重新输入'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        NavigatorUtils.goBack(context);
                                      },
                                      child: Text('确定'),
                                    ),
                                  ],
                                );
                              });
                        }else if(_pw_origin == pw1 || _pw_origin == pw2){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('提示'),
                                  content: Text('新密码不能与原密码相同，请重新输入'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        NavigatorUtils.goBack(context);
                                      },
                                      child: Text('确定'),
                                    ),
                                  ],
                                );
                              });
                        }
                        else if (pw1 == pw2 && pw1.length > 5 && pw2.length > 5) {
                          _createPassword(pw1);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('提示'),
                                  content: Text('密码已修改/创建完成'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  return PatternlockcreatePage();
                                                }), (route) => route == null);
                                      },
                                      child: Text('确定'),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      shape: StadiumBorder(side: BorderSide()),
                      child: Text(
                        "修改/创建密码",
                        style:
                            Theme.of(context).primaryTextTheme.headline5, //字体白色
                      ),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 90.0),
          ],
        )));
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        ' ',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
}
