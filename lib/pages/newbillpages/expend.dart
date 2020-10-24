import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:i_account/res/styles.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:i_account/widgets/mypickertool.dart';
import 'package:i_account/res/colours.dart';
import 'dart:convert';

class _UsNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value != "" &&
        value != defaultDouble.toString() &&
        strToFloat(value, defaultDouble) == defaultDouble) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class ExpendPage extends StatefulWidget {
  @override
  _ExpendPageState createState() => _ExpendPageState();
}

class _ExpendPageState extends State<ExpendPage> {
  DateTime nowtime = DateTime.now();
  var _accountTime =
      formatDate(DateTime.now(), [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
  var _accountAmount;
  var _accountCategory = '请选择分类';
  var _accountRemarks;
  var _accountAccount = '请选择账户';
  var _accountPerson = '请选择成员';

  var _accountPickerData = ["现金", "支付宝", "微信", "借记卡"];
  var _personPickerData = ["自己", "孩子", "父亲", "母亲"];
  var _categoryPickerData = '''
  [
  {"测试": ["三餐","零食","饮料","聚餐"]},
  {"学习": ["网课","图书"]},
  {"交通": ["地铁","公交","火车票","飞机票"]}
  ]
  ''';


  showCategoryPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(_categoryPickerData)),
        cancelText: '取消',
        confirmText: '确定',
        cancelTextStyle: TextStyle(color: kBtnColor, fontSize: kTextFontSize),
        confirmTextStyle: TextStyle(color: kBtnColor, fontSize: kTextFontSize),
        textAlign: TextAlign.right,
        itemExtent: kItemHeight,
        height: kPickerHeight,
        selectedTextStyle: TextStyle(color: Colors.black),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            _accountCategory = picker.adapter.text;
          });
          print(value.toString());
          print(picker.adapter.text);
        }).showModal(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return
        ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _getAmount(),
              _getTime(),
              _getCategory(),
              _getRemarks(),
              _getAccount(),
              _getPerson(),
              Gaps.vGap(60.0),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Text('确认'),
                  onPressed: () async {
                  },
                ),
              ),
            ],
    );
  }

  //获取金额
  _getAmount() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.money,
          color: Colors.blueGrey,
        ),
        title: Text("金额"),
        trailing: Container(
          width: 240.0,
          child: TextFormField(
            style: TextStyle(fontSize: 16, color: Colours.app_main),
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            inputFormatters: [_UsNumberTextInputFormatter()],
            decoration: const InputDecoration().copyWith(
                border: InputBorder.none,
                hintText: '请输入金额',
                counterText: "",
                contentPadding: EdgeInsets.only(right: 0)),
          ),
        ),
      ),
    );
  }

  //获取时间
  _getTime() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.access_time,
          color: Colors.greenAccent,
        ),
        title: Text("时间"),
        onTap: () {
          DatePicker.showDateTimePicker(context,
              // 是否展示顶部操作按钮
              showTitleActions: true,
              // change事件
              onChanged: (date) {
            print('change $date');
          },
              // 确定事件
              onConfirm: (date) {
            print('confirm $date');
            setState(() {
              _accountTime =
                  formatDate(date, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
            });
          },
              // 当前时间
              currentTime: DateTime.now(),
              // 语言
              locale: LocaleType.zh);
        },
        trailing: Text(
          _accountTime,
          style: TextStyle(fontSize: 16, color: Colours.app_main),
        ),
      ),
    );
  }

  //获取分类
  _getCategory() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.category,
          color: Colors.deepOrangeAccent,
        ),
        title: Text("分类"),
        onTap: () {
          showCategoryPicker(context);
        },
        trailing: Text(
          _accountCategory,
          style: TextStyle(fontSize: 16, color: Colours.app_main),
        ),
      ),
    );
  }

  //获取备注
  _getRemarks() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.note_add,
          color: Colors.purpleAccent,
        ),
        title: Text("备注"),
        trailing: Container(
          width: 240.0,
          child: TextFormField(
            style: TextStyle(fontSize: 16, color: Colours.app_main),
            textAlign: TextAlign.right,
            decoration: const InputDecoration().copyWith(
                border: InputBorder.none,
                hintText: '请输入备注',
                counterText: "",
                contentPadding: EdgeInsets.only(right: 0)),
          ),
        ),
      ),
    );
  }

  //获取账户
  _getAccount() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.account_balance_wallet,
          color: Colors.redAccent,
        ),
        title: Text("账户"),
        onTap: () {
          MyPickerTool.showStringPicker(context,
              data: _accountPickerData,
              normalIndex: 2,
              title: "请选择", clickCallBack: (int index, var str) {
            setState(() {
              _accountAccount = str;
            });
          });
        },
        trailing: Text(
          _accountAccount,
          style: TextStyle(fontSize: 16, color: Colours.app_main),
        ),
      ),
    );
  }

  //获取成员
  _getPerson() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.person,
          color: Colors.lightGreen,
        ),
        title: Text("成员"),
        onTap: () {
          MyPickerTool.showStringPicker(context,
              data: _personPickerData,
              normalIndex: 2,
              title: "请选择", clickCallBack: (int index, var str) {
            setState(() {
              _accountPerson = str;
            });
          });
        },
        trailing: Text(
          _accountPerson,
          style: TextStyle(fontSize: 16, color: Colours.app_main),
        ),
      ),
    );
  }
}
