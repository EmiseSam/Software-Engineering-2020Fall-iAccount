import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:gesture_recognition/gesture_view.dart';
import 'package:i_account/res/styles.dart';
import 'package:i_account/pages/loginpages/pw_change.dart';

class PatternlockcreatesecPage extends StatefulWidget {
  @override
  _PatternlockcreatesecPageState createState() => _PatternlockcreatesecPageState();
}

class _PatternlockcreatesecPageState extends State<PatternlockcreatesecPage> {
  List<int> result = [];
  bool _visible = false;//TODO 这里为了调试改成了默认false 要写一个两次密码相同才改为false的逻辑

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '修改手势密码',
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              child: Center(
                child: Text( '请重复输入密码',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
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
            Gaps.vGap(30),
            Offstage(
              offstage: _visible,
              child: SizedBox(
                height: 45.0,
                width: 270.0,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PwchangePage()));
                  },
                  shape: StadiumBorder(side: BorderSide()),
                  child: Text(
                    "确认密码",
                    style: Theme.of(context)
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
