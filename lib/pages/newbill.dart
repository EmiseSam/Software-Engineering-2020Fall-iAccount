import 'package:i_account/res/colours.dart';
import 'package:i_account/res/styles.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/bill/models/bill_record_response.dart';
import 'package:i_account/common/eventBus.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/routers/fluro_navigator.dart';
import 'package:i_account/util/utils.dart';
import 'package:i_account/widgets/input_textview_dialog.dart';
import 'package:i_account/widgets/number_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_account/widgets/my_pickertool.dart';
import 'package:i_account/router_jump.dart';

class NewBillPage extends StatefulWidget {
  const NewBillPage({Key key, this.recordModel}) : super(key: key);
  final BillRecordModel recordModel;

  @override
  State<StatefulWidget> createState() => _NewBillPageState();
}

class _NewBillPageState extends State<NewBillPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _tapItemController;
  String _remark = '';
  DateTime _time;
  String _dateString = '';
  String _numberString = '';
  bool _isAdd = false;
  String _accountString = '';
  String _memberString = '';
  String _projectString = '';
  String _storeString = '';
  String _expenCategory1String = '';
  String _incomeCategory1String = '';
  String _expenCategory2String = '';
  String _incomeCategory2String = '';

  var _accountPickerData;
  var _memberPickerData;
  var _projectPickerData;
  var _storePickerData;
  var _incomeCategory1PickerData;
  var _incomeCategory2PickerData;
  var _expenCategory1PickerData;
  var _expenCategory2PickerData;
  int flagIfHasData = 0;

  TabController _tabController;

  /// tabs
  final List<Tab> tabs = <Tab>[
    Tab(
      text: '支出',
    ),
    Tab(
      text: '收入',
    )
  ];

  Future<void> _loadAccountNames() async {
    List list = await dbHelp.getAccountList();
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.account);
    });
    _accountPickerData = listTemp;
  }

  Future<void> _loadMemberNames() async {
    List list = await dbHelp.getMembers();
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.member);
    });
    _memberPickerData = listTemp;
  }

  Future<void> _loadProjectNames() async {
    List list = await dbHelp.getProjects();
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.project);
    });
    _projectPickerData = listTemp;
  }

  Future<void> _loadStoreNames() async {
    List list = await dbHelp.getStores();
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.store);
    });
    _storePickerData = listTemp;
  }

  Future<void> _loadExpenCategory1Data() async {
    List list = await dbHelp.getCategories(1);
    _expenCategory1PickerData = list;
  }

  Future<void> _loadIncomeCategory1Data() async {
    List list = await dbHelp.getCategories(2);
    _incomeCategory1PickerData = list;
  }

  Future<void> _loadExpenCategory2Data(categoryName1) async {
    List list = await dbHelp.getCategories(1, categoryName1);
    _expenCategory2PickerData = list;
  }

  Future<void> _loadIncomeCategory2Data(categoryName1) async {
    List list = await dbHelp.getCategories(2, categoryName1);
    _incomeCategory2PickerData = list;
  }

  void _updateInitData() {
    if (widget.recordModel != null) {
      _time = DateTime.fromMillisecondsSinceEpoch(
          widget.recordModel.updateTimestamp);
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

      if (widget.recordModel.member.isNotEmpty) {
        _memberString = widget.recordModel.member;
      }

      if (widget.recordModel.project.isNotEmpty) {
        _projectString = widget.recordModel.project;
      }

      if (widget.recordModel.store.isNotEmpty) {
        _storeString = widget.recordModel.store;
      }

      if (widget.recordModel.account.isNotEmpty) {
        _accountString = widget.recordModel.account;
      }

      if (widget.recordModel.remark.isNotEmpty) {
        _remark = widget.recordModel.remark;
      }

      if (widget.recordModel.money != null) {
        flagIfHasData = 1;
        _numberString = Utils.formatDouble(double.parse(
            _numberString = widget.recordModel.money.toStringAsFixed(2)));
      }

      if (widget.recordModel.typeofB == 2) {
        _tabController.index = 1;
        if (widget.recordModel.classification1.isNotEmpty) {
          _incomeCategory1String = widget.recordModel.classification1;
        }
        if (widget.recordModel.classification2.isNotEmpty) {
          _incomeCategory2String = widget.recordModel.classification2;
        }
      } else {
        if (widget.recordModel.classification1.isNotEmpty) {
          _expenCategory1String = widget.recordModel.classification1;
        }
        if (widget.recordModel.classification2.isNotEmpty) {
          _expenCategory2String = widget.recordModel.classification2;
        }
      }
    } else {
      _time = DateTime.now();
      _dateString =
          '今天 ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //动画执行结束时反向执行动画
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              //动画恢复到初始状态时执行动画（正向）
              _animationController.forward();
            }
          });
    // 启动动画
    _animationController.forward();

    _tapItemController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //动画执行结束 反向动画
              _tapItemController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              //动画恢复到初始状态 停止掉
              _tapItemController.stop();
            }
          });

    _updateInitData();
    _loadExpenCategory1Data();
    _loadIncomeCategory1Data();
    _loadAccountNames();
    _loadMemberNames();
    _loadProjectNames();
    _loadStoreNames();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    _tapItemController.stop();
    _tapItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      appBar: MyAppBar(
        // centerTitle: true,
        titleWidget: TabBar(
          // tabbar菜单
          controller: _tabController,
          tabs: tabs,
          indicatorColor: Colours.app_main,
          unselectedLabelColor: Colours.app_main.withOpacity(0.8),
          labelColor: Colours.app_main,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          indicatorWeight: 1,
          // 下划线高度
          isScrollable: true, // 是否可以滑动
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
          child: Icon(
            Icons.close,
            color: Colours.app_main,
          ),
          onPressed: () {
            NavigatorUtils.goBack(context);
          },
        ),
      ),

      resizeToAvoidBottomInset: false, // 默认true键盘弹起不遮挡
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildExpenBody(),
          _buildIncomeBody(),
        ],
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
  void _record(int value) {
    String categoryOne;
    String categoryTwo;

    if (_numberString.isEmpty) {
      return;
    }

    _isAdd = false;

    if (_tabController.index == 0) {
      categoryOne = _expenCategory1String;
      categoryTwo = _expenCategory2String;
    } else {
      categoryOne = _incomeCategory1String;
      categoryTwo = _incomeCategory2String;
    }

    BillRecordModel model = BillRecordModel(
        widget.recordModel != null ? widget.recordModel.id : null,
        double.parse(_numberString),
        _memberString,
        _accountString,
        _remark,
        _tabController.index + 1,
        categoryOne,
        categoryTwo,
        _projectString,
        _storeString,
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

  /// 支出构建
  _buildExpenBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                Icons.money,
                color: Colors.blueGrey,
              ),
              title: Text("金额"),
              trailing: Text(
                _numberString.isEmpty ? '0.00' : _numberString,
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.category,
                color: Colors.deepOrangeAccent,
              ),
              title: Text("一级分类"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _expenCategory1PickerData,
                    normalIndex: 0,
                    title: "请选择一级分类", clickCallBack: (int index, var str) {
                  setState(() {
                    _expenCategory1String = str;
                    _loadExpenCategory2Data(str);
                  });
                });
              },
              trailing: Text(
                _expenCategory1String == '' ? '一级分类' : _expenCategory1String,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.category_outlined,
                color: Colors.deepOrangeAccent,
              ),
              title: Text("二级分类"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _expenCategory2PickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                  setState(() {
                    _expenCategory2String = str;
                  });
                });
              },
              trailing: Text(
                _expenCategory2String == '' ? '二级分类' : _expenCategory2String,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.access_time,
                color: Colors.greenAccent,
              ),
              title: Text("时间"),
              onTap: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    theme: DatePickerTheme(
                        doneStyle:
                            TextStyle(fontSize: 16, color: Colours.app_main),
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
              trailing: Text(
                _dateString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: Colors.redAccent,
              ),
              title: Text("账户"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _accountPickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                  setState(() {
                    _accountString = str;
                  });
                });
              },
              trailing: Text(
                _accountString.isEmpty ? '账户' : _accountString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.lightGreen,
              ),
              title: Text("成员"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _memberPickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                  setState(() {
                    _memberString = str;
                  });
                });
              },
              trailing: Text(
                _memberString.isEmpty ? '成员' : _memberString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.drive_file_rename_outline,
                color: Colors.lightGreen,
              ),
              title: Text("项目"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _projectPickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                      setState(() {
                        _projectString = str;
                      });
                    });
              },
              trailing: Text(
                _projectString.isEmpty ? '项目' : _projectString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.store,
                color: Colors.lightGreen,
              ),
              title: Text("商家"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _storePickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                      setState(() {
                        _storeString = str;
                      });
                    });
              },
              trailing: Text(
                _storeString.isEmpty ? '商家' : _storeString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.mark_chat_read_outlined,
                color: Colors.lightGreen,
              ),
              title: Text("备注"),
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
              trailing: Text(
                _remark.isEmpty ? '备注' : _remark,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Gaps.vGap(73),
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
            nextCallback: () async {
              if (_accountString.isEmpty ||
                  _expenCategory1String.isEmpty ||
                  _expenCategory2String.isEmpty) {
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("提示"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("没有选择账户/没有选择一级分类/没有选择二级分类，请重新检查！")
                          ],
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
              if (_isAdd == true) {
                _addNumber();
              }
              var res = await dbHelp.getAccount(_accountString);
              int typeAccount = res.typeofA;
              _record(typeAccount);
              _clearZero();
              setState(() {});
            },
            // 保存
            saveCallback: () async {
              if (_accountString.isEmpty ||
                  _expenCategory1String.isEmpty ||
                  _expenCategory2String.isEmpty) {
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("提示"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("没有选择账户/没有选择一级分类/没有选择二级分类，请重新检查！")
                          ],
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
              } else {
                if (flagIfHasData == 1) {
                  String ac = widget.recordModel.account;
                  dbHelp.getAccountBalance(ac);
                } else {
                  dbHelp.getAccountBalance(_accountString);
                }
                var res = await dbHelp.getAccount(_accountString);
                int typeAccount = res.typeofA;
                _record(typeAccount);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouterJump()), ModalRoute.withName('/'));
              }
            },
          ),
          MediaQuery.of(context).padding.bottom > 0
              ? Gaps.vGapLine(gap: 0.3)
              : Gaps.empty,
        ],
      ),
    );
  }

  /// 收入构建
  _buildIncomeBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                Icons.money,
                color: Colors.blueGrey,
              ),
              title: Text("金额"),
              trailing: Text(
                _numberString.isEmpty ? '0.00' : _numberString,
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.category,
                color: Colors.deepOrangeAccent,
              ),
              title: Text("一级分类"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _incomeCategory1PickerData,
                    normalIndex: 0,
                    title: "请选择一级分类", clickCallBack: (int index, var str) {
                  setState(() {
                    _incomeCategory1String = str;
                    _loadIncomeCategory2Data(str);
                  });
                });
              },
              trailing: Text(
                _incomeCategory1String == '' ? '一级分类' : _incomeCategory1String,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.category_outlined,
                color: Colors.deepOrangeAccent,
              ),
              title: Text("二级分类"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _incomeCategory2PickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                  setState(() {
                    _incomeCategory2String = str;
                  });
                });
              },
              trailing: Text(
                _incomeCategory2String == '' ? '二级分类' : _incomeCategory2String,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.access_time,
                color: Colors.greenAccent,
              ),
              title: Text("时间"),
              onTap: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    theme: DatePickerTheme(
                        doneStyle:
                            TextStyle(fontSize: 16, color: Colours.app_main),
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
              trailing: Text(
                _dateString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: Colors.redAccent,
              ),
              title: Text("账户"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _accountPickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                  setState(() {
                    _accountString = str;
                  });
                });
              },
              trailing: Text(
                _accountString.isEmpty ? '账户' : _accountString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.lightGreen,
              ),
              title: Text("成员"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _memberPickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                  setState(() {
                    _memberString = str;
                  });
                });
              },
              trailing: Text(
                _memberString.isEmpty ? '成员' : _memberString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.drive_file_rename_outline,
                color: Colors.lightGreen,
              ),
              title: Text("项目"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _projectPickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                      setState(() {
                        _projectString = str;
                      });
                    });
              },
              trailing: Text(
                _projectString.isEmpty ? '项目' : _projectString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.store,
                color: Colors.lightGreen,
              ),
              title: Text("商家"),
              onTap: () {
                MyPickerTool.showStringPicker(context,
                    data: _storePickerData,
                    normalIndex: 0,
                    title: "请选择", clickCallBack: (int index, var str) {
                      setState(() {
                        _storeString = str;
                      });
                    });
              },
              trailing: Text(
                _storeString.isEmpty ? '商家' : _storeString,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.mark_chat_read_outlined,
                color: Colors.lightGreen,
              ),
              title: Text("备注"),
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
              trailing: Text(
                _remark.isEmpty ? '备注' : _remark,
                style: TextStyle(fontSize: 16, color: Colours.app_main),
              ),
            ),
          ),
          Gaps.vGap(73),
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
            nextCallback: () async {
              if (_accountString.isEmpty ||
                  _incomeCategory1String.isEmpty ||
                  _incomeCategory2String.isEmpty) {
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("提示"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("没有选择账户/没有选择一级分类/没有选择二级分类，请重新检查！")
                          ],
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
              if (_isAdd == true) {
                _addNumber();
              }
              var res = await dbHelp.getAccount(_accountString);
              int typeAccount = res.typeofA;
              _record(typeAccount);
              _clearZero();
              setState(() {});
            },
            // 保存
            saveCallback: () async {
              if (_accountString.isEmpty ||
                  _incomeCategory1String.isEmpty ||
                  _incomeCategory2String.isEmpty) {
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("提示"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("没有选择账户/没有选择一级分类/没有选择二级分类，请重新检查！")
                          ],
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
              } else {
                if (flagIfHasData == 1) {
                  String ac = widget.recordModel.account;
                  dbHelp.getAccountBalance(ac);
                } else {
                  dbHelp.getAccountBalance(_accountString);
                }
                var res = await dbHelp.getAccount(_accountString);
                int typeAccount = res.typeofA;
                _record(typeAccount);
                NavigatorUtils.goBack(context);
              }
            },
          ),
          MediaQuery.of(context).padding.bottom > 0
              ? Gaps.vGapLine(gap: 0.3)
              : Gaps.empty,
        ],
      ),
    );
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
