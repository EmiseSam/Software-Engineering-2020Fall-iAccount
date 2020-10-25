import 'package:i_account/res/colours.dart';
import 'package:i_account/res/styles.dart';
import 'package:i_account/bill/models/bill_record_response.dart';
import 'package:i_account/common/eventBus.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/util/utils.dart';
import 'package:i_account/widgets/highlight_well.dart';
import 'package:i_account/widgets/input_textview_dialog.dart';
import 'package:i_account/widgets/number_keyboard.dart';
import 'categroy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key key, this.recordModel}) : super(key: key);
  final BillRecordModel recordModel;

  @override
  State<StatefulWidget> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> with TickerProviderStateMixin {

  String _remark = '';
  DateTime _time;
  String _dateString = '';
  String _numberString = '';
  bool _isAdd = false;

  List<Widget> listViews = <Widget>[];
  String categroyFirst = '一级分类';
  String categroySecond = '二级分类（点击选择）';
  String itemName = '';
  String itemImage = '';
  int itemType = 0;


  void _updateInitData() {
    if (widget.recordModel != null) {
      categroyFirst = widget.recordModel.categoryName;
      categroySecond = widget.recordModel.categoryName;
      itemName = widget.recordModel.categoryName;
      itemImage = widget.recordModel.image;
      itemType = widget.recordModel.type;
      _time = DateTime.fromMillisecondsSinceEpoch(widget.recordModel.updateTimestamp);
      DateTime now = DateTime.now();
      if (_time.year == now.year &&
          _time.month == now.month &&
          _time.day == now.day) {
        _dateString =
        '今天 ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
      } else if (_time.year != now.year) {
        _dateString =
        '${_time.year}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
      } else {
        _dateString =
        '${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
      }

      if (widget.recordModel.remark.isNotEmpty) {
        _remark = widget.recordModel.remark;
      }


      if (widget.recordModel.money != null) {
        _numberString = Utils.formatDouble(double.parse(_numberString = widget.recordModel.money.toStringAsFixed(2)));
      }

    }
    else {
      _time = DateTime.now();
      _dateString =
      '今天 ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void initState() {
    super.initState();
    _updateInitData();
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance =
    ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
      ..init(context);

    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          title: Text('编辑账单'),
          leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.times),
              iconSize: 18,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(children: [

            //金额
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: FaIcon(
                    FontAwesomeIcons.creditCard,
                    color: Color(0xFF191919),
                    size: 18,
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: Text(
                      _numberString.isEmpty ? '0.0' : _numberString,
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(48),
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),

            //一级分类
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: FaIcon(
                      FontAwesomeIcons.poll,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 15),
                    child: Text(categroyFirst,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        )),
                  ),
                ],
              ),
            ]),

            //二级分类
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CategroyView();
                      })).then((data) {
                    if (data != null) {
                      setState(() {
                        categroyFirst = data['categroyFirst'];
                        categroySecond = data['categroySecond'];
                        itemName = data['itemName'];
                        itemImage = data['itemImage'];
                        itemType = data['itemType'];
                      });
                    }
                  });
                },
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 18),
                        child: FaIcon(
                          FontAwesomeIcons.layerGroup,
                          size: 20,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 15),
                        child: Text(categroySecond,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            )),
                      ),
                    ],
                  ),
                ])),

            //时间
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child:Column(children: [
                InkWell(
                    onTap: () async {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          theme: DatePickerTheme(
                              doneStyle: TextStyle(
                                  fontSize: 16, color: Colours.app_main),
                              cancelStyle:
                              TextStyle(fontSize: 16, color: Colours.gray)),
                          locale: LocaleType.zh, onConfirm: (date) {
                            _time = date;
                            DateTime now = DateTime.now();
                            if (_time.year == now.year &&
                                _time.month == now.month &&
                                _time.day == now.day) {
                              _dateString =
                              '今天 ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
                            } else if (_time.year != now.year) {
                              _dateString =
                              '${_time.year}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
                            } else {
                              _dateString =
                              '${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
                            }
                            setState(() {});
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: FaIcon(
                              FontAwesomeIcons.solidCalendarAlt,
                              color: Color(0xFF191919),
                              size: 20,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Container(
                            alignment: Alignment(0, 0),
                            child: Text(_dateString,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                )),
                          ),
                        ),
                      ],
                    )
                ),
              ]),
            ),

            //备注
            HighLightWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return TextViewDialog(
                        confirm: (text) {
                          setState(() {
                            _remark = text;
                          });
                        },
                      );
                    });
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: FaIcon(
                            FontAwesomeIcons.creditCard,
                            color: Color(0xFF191919),
                            size: 18,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _remark.isEmpty ? '填写备注' : _remark,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(30),
                                color: Colours.gray_c),
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ),

            Gaps.vGap(3),
            Gaps.vGapLine(gap: 0.3),
            MyKeyBoard(
              isAdd: _isAdd,
              // 键盘输入
              numberCallback: (number) => inputVerifyNumber(number),
              // 删除
              deleteCallback: () {
                if (_numberString.length > 0) {
                  setState(() {
                    _numberString =
                        _numberString.substring(0, _numberString.length - 1);
                  });
                }
              },
              // 清除
              clearZeroCallback: () {
                _clearZero();
              },
              // 等于
              equalCallback: () {
                setState(() {
                  _addNumber();
                });
              },
              //继续
              nextCallback: () {
                if (_isAdd == true) {
                  _addNumber();
                }
                _record();
                _clearZero();
                setState(() {});
              },
              // 保存
              saveCallback: () {
                _record();
                //NavigatorUtils.goBack(context);
                Navigator.pop(context);
              },
            ),
            MediaQuery.of(context).padding.bottom > 0
                ? Gaps.vGapLine(gap: 0.3)
                : Gaps.empty,
          ]),
        ),
      ),
    );
  }


  /// 相加
  void _addNumber() {
    _isAdd = false;
    List<String> numbers = _numberString.split('+');
    double number = 0.0;
    for (String item in numbers) {
      if (item.isEmpty == false) {
        number += double.parse(item);
      }
    }
    String numberString = number.toString();
    if (numberString.split('.').last == '0') {
      numberString = numberString.substring(0, numberString.length - 2);
    }
    _numberString = numberString;
  }

  /// 记账保存
  void _record() {
    if (_numberString.isEmpty || _numberString == '0.') {
      return;
    }
    _isAdd = false;

    BillRecordModel model = BillRecordModel(
        widget.recordModel != null ? widget.recordModel.id : null,
        double.parse(_numberString),
        _remark,
        itemType,
        itemName,
        itemImage,
        DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch)
            .toString(),
        _time.millisecondsSinceEpoch,
        DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch)
            .toString(),
        _time.millisecondsSinceEpoch);


    dbHelp.insertBillRecord(model).then((value) {
      bus.trigger(bus.bookkeepingEventName);
    });
  }

  /// 清零
  void _clearZero() {
    setState(() {
      _isAdd = false;
      _numberString = '';
    });
  }


  /// 键盘输入验证
  void inputVerifyNumber(String number) {
    //小数点精确分，否则不能输入
    //加法
    if (_numberString.isEmpty) {
      //没输入的时候，不能输入+或者.
      if (number == '+') {
        return;
      }

      if (number == '.') {
        setState(() {
          _numberString += '0.';
        });
        return;
      }

      setState(() {
        _numberString += number;
      });
    } else {
      List<String> numbers = _numberString.split('');
      if (numbers.length == 1) {
        // 当只有一个数字
        if (numbers.first == '0') {
          //如果第一个数字是0，那么输入其他数字和+不生效
          if (number == '.') {
            setState(() {
              _numberString += number;
            });
          } else if (number != '+') {
            setState(() {
              _numberString = number;
            });
          }
        } else {
          //第一个数字不是0 为1-9
          setState(() {
            if (number == '+') {
              _isAdd = true;
            }
            _numberString += number;
          });
        }
      } else {
        List<String> temps = _numberString.split('+');
        if (temps.last.isEmpty && number == '+') {
          //加号
          return;
        }

        //拿到最后一个数字
        String lastNumber = temps.last;
        List<String> lastNumbers = lastNumber.split('.');
        if (lastNumbers.last.isEmpty && number == '.') {
          return;
        }
        if (lastNumbers.length > 1 &&
            lastNumbers.last.length >= 2 &&
            number != '+') {
          return;
        }

        setState(() {
          if (number == '+') {
            _isAdd = true;
          }
          _numberString += number;
        });
      }
    }
  }
}
