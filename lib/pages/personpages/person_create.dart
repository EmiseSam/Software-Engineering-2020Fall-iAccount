import 'package:i_account/db/account_classification.dart';
import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/tabs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_account/widgets/mypickertool.dart';
import 'package:i_account/widgets/highlight_well.dart';
import 'package:flutter/services.dart';
import 'package:i_account/db/db_helper_demo.dart';
import 'package:i_account/db/member.dart';

class AccountCreatePage extends StatefulWidget {
  @override
  _AccountCreatePageState createState() =>
      _AccountCreatePageState();
}

class _AccountCreatePageState extends State<AccountCreatePage> {

  TextEditingController _accountName = new TextEditingController();

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '创建成员',
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
    ScreenUtil.instance =
    ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
      ..init(context);
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
        actionName: "确定",
        onPressed: () async{
          Member m = new Member(_accountName.text);
          await dbAccount.insertMember(m);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return Tabs();
              }), (route) => route == null);
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("提示"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("成员创建成功！")],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
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

        },
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 48,
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text("成员名称", style: TextStyle(fontSize: 18),),
            ),
            TextField(
              decoration: new InputDecoration(
                hintText: "请输入成员名称",
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid),
                ),
                prefixIcon: Icon(Icons.person),
              ),
              controller: _accountName,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;
  ///允许的小数位数，-1代表不限制位数
  int digit;
  _MyNumberTextInputFormatter({this.digit=-1});
  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }
  ///获取目前的小数位数
  static int getValueDigit(String value){
    if(value.contains(".")){
      return value.split(".")[1].length;
    }else{
      return -1;
    }
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if(value=="-"){
      value = "-";
      selectionIndex++;
    }else if (value != "" &&
        value != defaultDouble.toString() &&
        strToFloat(value, defaultDouble) == defaultDouble ||
        getValueDigit(value) > digit) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}


