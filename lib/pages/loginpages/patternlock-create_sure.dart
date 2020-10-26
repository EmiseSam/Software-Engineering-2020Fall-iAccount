import 'package:i_account/pages/tabs.dart';
import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:gesture_recognition/gesture_view.dart';
import 'package:i_account/res/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternlockcreatesecPage extends StatefulWidget {
  @override
  _PatternlockcreatesecPageState createState() =>
      _PatternlockcreatesecPageState();
}

class _PatternlockcreatesecPageState extends State<PatternlockcreatesecPage> {
  List<int> result = [];
  String papw1;
  bool _visible = true;
  bool _patternvisible = false;

  @override
  void initState() {
    super.initState();
    _getPatternPasswordOne(); //获取本地存储的数据
  }

  void _createPatternPasswordTwo(value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("patternpw2", value);
  }

  void _getPatternPasswordOne() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      papw1 = sharedPreferences.get('patternpw1') ?? '';
    });
  }

  _buildAppBarTitle() {
    if (papw1 == result.toString()) {
      _visible = false;
      _patternvisible = true;
    }
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '修改/创建手势密码',
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              child: Center(
                child: Text(
                  '请重复输入密码',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Offstage(
              offstage: _patternvisible,
              child: Center(
                child: GestureView(
                  immediatelyClear: true,
                  size: MediaQuery.of(context).size.width,
                  onPanUp: (List<int> items) {
                    setState(() {
                      result = items;
                    });
                  },
                ),
              ),
            ),
            Gaps.vGap(30),
            Offstage(
              offstage: _visible,
              child: SizedBox(
                height: 45.0,
                width: 270.0,
                child: RaisedButton(
                  onPressed: () {
                    _createPatternPasswordTwo(result.toString());
                    showDialog<Null>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("提示"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[Text("密码已修改/创建完成")],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Tabs()));
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
                  shape: StadiumBorder(side: BorderSide()),
                  child: Text(
                    "确认密码",
                    style: Theme.of(context).primaryTextTheme.headline5, //字体白色
                  ),
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
