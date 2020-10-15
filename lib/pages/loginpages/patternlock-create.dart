import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:gesture_recognition/gesture_view.dart';

class PatternlockcreatePage extends StatefulWidget {
  @override
  _PatternlockcreatePageState createState() => _PatternlockcreatePageState();
}

class _PatternlockcreatePageState extends State<PatternlockcreatePage> {
  List<int> result = [];


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
                child: Text( '还没改完',
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
            )
          ],
        ),
      ),
    );
  }
}
