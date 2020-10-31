import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_account/res/colours.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/projectpages/bill_search_project_withtype.dart';
import 'package:i_account/common/eventBus.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/res/styles.dart';
import 'package:i_account/util/dateUtils.dart';
import 'package:i_account/util/utils.dart';
import 'package:i_account/widgets/calendar_page.dart';
import 'package:i_account/widgets/highlight_well.dart';
import 'package:i_account/widgets/state_layout.dart';

class ChartProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChartProjectPageState();
}

class ChartProjectPageState extends State<StatefulWidget> {
  @override
  //保存状态
  bool get wantKeepAlive => true;

  /// 类型 1支出 2收入
  int _type = 1;

  /// 当月总支出金额
  double _monthExpenMoney = 0.0;

  /// 当月总收入
  double _monthIncomeMoney = 0.0;

  List<charts.Series<ChartItemModel, int>> _expendChartDatas = List();
  List<charts.Series<ChartItemModel, int>> _incomeChartDatas = List();

  List<ChartItemModel> _datas = List();

  String myYear1 = "1971";
  String myMonth1 = "01";
  String myYear2 = "2055";
  String myMonth2 = "12";

  Future<void> _initDatas() async {
    // 时间戳
    int startTime =
        DateTime(int.parse(myYear1), int.parse(myMonth1), 1, 0, 0, 0, 0)
            .millisecondsSinceEpoch;
    int endTime = DateTime(
            int.parse(myYear2),
            int.parse(myMonth2),
            DateUtls.getDaysNum(int.parse(myYear2), int.parse(myMonth2)),
            23,
            59,
            59,
            999)
        .millisecondsSinceEpoch;
    if (startTime > endTime) {
      var temp;
      temp = startTime;
      startTime = endTime;
      endTime = temp;
      temp = myYear1;
      myYear1 = myYear2;
      myYear2 = temp;
      temp = myMonth1;
      myMonth1 = myMonth2;
      myMonth2 = temp;
    }
    dbHelp.getBillListType(startTime, endTime, _type).then((list) {
      _monthExpenMoney = 0.0;
      _monthIncomeMoney = 0.0;
      Map map = Map();
      list.forEach((item) {
        if (item.typeofB == 1) {
          // 支出
          _monthExpenMoney += item.money;
        } else if (item.typeofB == 2) {
          // 收入
          _monthIncomeMoney += item.money;
        }

        if (item.typeofB == _type) {
          map[item.project] = null;
        }
      });

      List<ChartItemModel> chartItems = List();
      int index = 1;
      map.keys.forEach((key) {
        // 查找相同分类的账单
        var items = list.where((item) => item.project == key);

        double money = 0.0;
        items.forEach((item) {
          money += item.money;
        });


        double ratio =
            money / (_type == 1 ? _monthExpenMoney : _monthIncomeMoney);
        ChartItemModel itemModel =
            ChartItemModel(index, key, money, ratio, items.length);
        chartItems.add(itemModel);
        index += 1;
      });

      _datas = chartItems;
      // 排序
      _datas.sort((left, right) => right.money.compareTo(left.money));

      if (_type == 1) {
        _expendChartDatas = [
          new charts.Series<ChartItemModel, int>(
            id: 'Sales',
            domainFn: (ChartItemModel item, _) => item.id,
            measureFn: (ChartItemModel item, _) => item.money,
            data: chartItems,
            overlaySeries: true,
            labelAccessorFn: (ChartItemModel item, _) =>
                '${item.project} ${Utils.formatDouble(double.parse((item.ratio * 100).toStringAsFixed(2)))}%',
          ),
        ];
      } else {
        _incomeChartDatas = [
          new charts.Series<ChartItemModel, int>(
            id: 'Sales',
            domainFn: (ChartItemModel item, _) => item.id,
            measureFn: (ChartItemModel item, _) => item.money,
            data: chartItems,
            overlaySeries: true,
            labelAccessorFn: (ChartItemModel item, _) =>
                '${item.project} ${Utils.formatDouble(double.parse((item.ratio * 100).toStringAsFixed(2)))}%',
          ),
        ];
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    _initDatas();

    // 订阅监听
    bus.add(bus.bookkeepingEventName, (arg) {
      _initDatas();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.only(top: 15),
            sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      HighLightWell(
                        onTap: () {
                          _seletedType(1);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.indeterminate_check_box_outlined),
                            Text(_monthExpenMoney == 0 ?"支出":
                              '支出  ¥${Utils.formatDouble(double.parse(_monthExpenMoney.toStringAsFixed(2)))}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Gaps.hGap(20),
                      HighLightWell(
                        onTap: () {
                          _seletedType(2);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add_box),
                            Text(_monthIncomeMoney == 0 ? '收入' :
                              '收入  ¥${Utils.formatDouble(double.parse(_monthIncomeMoney.toStringAsFixed(2)))}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: OverflowBox(
                        minWidth: MediaQuery.of(context).size.width,
                        child: charts.PieChart(
                            _type == 1 ? _expendChartDatas : _incomeChartDatas,
                            animate: true,
                            defaultRenderer: charts.ArcRendererConfig(
                                arcRendererDecorators: [
                                  charts.ArcLabelDecorator(
                                    labelPosition: charts.ArcLabelPosition.auto,
                                  ),
                                ]))),
                  ),
                ]);
              }, childCount: 1),
            ),
          ),
          _datas.length > 0
              ? SliverPadding(
                  padding: const EdgeInsets.only(top: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return HighLightWell(
                        child: _buildItem(index),
                      );
                    }, childCount: _datas.length),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil.getInstance().setHeight(120)),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return const StateLayout(
                        hintText: '没有账单',
                      );
                    }, childCount: 1),
                  ),
                ),
        ],
      ),
    );
  }

  void _seletedType(int type) {
    _type = type;
    _initDatas();
  }

  /// 设置appbartitleView
  _buildAppBarTitle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ButtonTheme(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: FlatButton(
              child: (myYear1 == "1971")
                  ? Icon(Icons.chevron_left)
                  : Text(
                      '$myYear1-$myMonth1',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(34),
                          color: Colours.app_main),
                    ),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CalendarMonthDialog(
                      checkTap: (year, month) {
                        if (myYear1 != year || myMonth1 != month) {
                          myYear1 = year;
                          myMonth1 = month;
                          _initDatas();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          Text(
            "按项目查看",
            style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(34),
                color: Colours.app_main),
          ),
          ButtonTheme(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: FlatButton(
              child: (myYear2 == "2055")
                  ? Icon(Icons.chevron_right)
                  : Text(
                      '$myYear2-$myMonth2',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(34),
                          color: Colours.app_main),
                    ),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CalendarMonthDialog(
                      checkTap: (year, month) {
                        if (myYear2 != year || myMonth2 != month) {
                          myYear2 = year;
                          myMonth2 = month;
                          _initDatas();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(int index) {
    ChartItemModel model = _datas[index];
    return HighLightWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return BillSearchListProjectWithtype(
              model.project,_type);
        }));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            border: Border(
                top: index == 0
                    ? BorderSide(width: 0.6, color: Colours.line)
                    : BorderSide(width: 0.00001, color: Colors.white),
                bottom: BorderSide(width: 0.6, color: Colours.line))),
        child: Row(
          children: <Widget>[
            Icon(Icons.drive_file_rename_outline),
            Gaps.hGap(ScreenUtil.getInstance().setWidth(32)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  model.project == '' ? "未指定项目" : model.project,
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(32),
                      color: Colours.dark),
                ),
                Text(
                  '${Utils.formatDouble(double.parse((model.ratio * 100).toStringAsFixed(2)))}% ${model.number}笔',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil.getInstance().setSp(24),
                      color: Colours.normalBlack),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${Utils.formatDouble(model.money)}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                maxLines: 1,
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(36),
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartItemModel {
  final int id;
  final String project;
  final double money;
  final double ratio;
  final int number;

  ChartItemModel(this.id, this.project, this.money, this.ratio,
      this.number);
}
