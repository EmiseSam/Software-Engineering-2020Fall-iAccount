import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'dart:ui';
import 'package:gesture_recognition/gesture_view.dart';
import 'package:i_account/pages/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternlockPage extends StatefulWidget {
  @override
  _PatternlockPageState createState() => _PatternlockPageState();
}

class _PatternlockPageState extends State<PatternlockPage> {

  String patternpw;

  @override
  void initState() {
    super.initState();
    _getPatternlockPW();//获取本地存储的数据
  }

  void _getPatternlockPW()  async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      patternpw = sharedPreferences.get('patternpw2') ?? '';
    });
  }

  List<int> curResult = [];
  //List<int> correctResult = [0,1,2,5,8,7,6];
  int status = 0; // 0: NONE,1: SUCCESS,2: ERROR
  List<int> onlyShowItems;
  GlobalKey<GestureState> gestureStateKey = GlobalKey();

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '使用手势密码解锁',
          style: TextStyle(
              fontSize: 18,
              color: Colours.app_main,
              fontWeight: FontWeight.w600
          ),
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
            SizedBox(height: 150.0),
            Container(
              height: 60,
              child: Center(
                child: Text(
                  status == 0 ? "" : (status == 1 ? " " : "密码错误，请重试"),
                  style: TextStyle(
                      fontSize: 24,
                      color: status == 1 ? Colors.blue : Colors.red
                  ),
                ),
              ),
            ),
            Center(
              child: GestureView(
                key: this.gestureStateKey,
                size: MediaQuery.of(context).size.width*0.8,
                selectColor: Colors.blue,
                onPanUp: (List<int> items) {
                  analysisGesture(items);
                },
                onPanDown: () {
                  gestureStateKey.currentState.selectColor = Colors.blue;
                  setState(() {
                    status = 0;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
/*
  analysisGesture(List<int> items) {
    bool isCorrect = true;
    if (items.length == correctResult.length) {
      for (int i = 0 ; i < items.length ; i++) {
        if (items[i] != correctResult[i]) {
          isCorrect = false;
          break;
        }
      }
      gestureStateKey.currentState.selectColor = Colors.blue;
    } else {
      isCorrect = false;
      gestureStateKey.currentState.selectColor = Colors.red;
    }
*/
  analysisGesture(List<int> items) {
    bool isCorrect;
    if(items.toString() != patternpw){
      isCorrect = false;
      gestureStateKey.currentState.selectColor = Colors.red;
    }

    if(items.toString() == patternpw){
      isCorrect = true;
    }

    if(isCorrect){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
              builder: (BuildContext context) {
                return Tabs();
              }), (route) => route == null);
    }

    setState(() {
      status = isCorrect ? 1 : 2;
      curResult = items;
    });
  }

}
