import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:gesture_recognition/gesture_view.dart';
import 'package:i_account/pages/loginpages/patternlock-create_sure.dart';
import 'package:i_account/res/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternlockcreatePage extends StatefulWidget {
  @override
  _PatternlockcreatePageState createState() => _PatternlockcreatePageState();
}

class _PatternlockcreatePageState extends State<PatternlockcreatePage> {
  List<int> result = [];
  bool _visible = true;
  bool _patternvisible = true;

  void _createPatternPasswordOne(value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("patternpw1", value);
  }

  _buildAppBarTitle() {
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


  String _TextBuilding() {
    String _textString = '';
    if (result.length == 0) {
      _textString = '';
      _visible = true;
      _patternvisible = false;
    } else if (result.length < 5) {
      _textString = '密码长度小于5，请重试';
      _visible = true;
      _patternvisible = false;
    } else if (result.length >= 5) {
      _textString = '';
      _createPatternPasswordOne(result.toString());
      _visible = false;
      _patternvisible = true;
    }
    return _textString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              child: Center(
                child: Text(_TextBuilding(),
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
                  size: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => PatternlockcreatesecPage()));
                  },
                  shape: StadiumBorder(side: BorderSide()),
                  child: Text(
                    "重复确认密码",
                    style: Theme
                        .of(context)
                        .primaryTextTheme
                        .headline5, //字体白色
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
