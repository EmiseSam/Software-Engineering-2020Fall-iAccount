import 'dart:async';
import 'package:i_account/bill/models/bill_record_group.dart';
import 'package:i_account/bill/models/bill_record_response.dart';
import 'package:i_account/common/eventBus.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/db/db_helper_account.dart';
import 'package:i_account/res/colours.dart';
import 'package:i_account/res/styles.dart';
import 'package:i_account/routers/fluro_navigator.dart';
import 'package:i_account/util/dateUtils.dart';
import 'package:i_account/util/utils.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/widgets/calendar_page.dart';
import 'package:i_account/widgets/highlight_well.dart';
import 'package:i_account/widgets/state_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:i_account/pages/newbill.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  //保存状态
  bool get wantKeepAlive => true;

  ScrollController _controller = ScrollController();

  /// 是否显示返回顶部按钮
  bool _isShowToTopBtn = false;

  BillRecordMonth _monthModel = BillRecordMonth(0, 0, []);

  String myYear1 = "1971";
  String myMonth1 = "01";
  String myYear2 = "2055";
  String myMonth2 = "12";

  /// 获取当前月份的数据
  Future<void> getCurrentMonthDatas() async {
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

    dbHelp.getBillRecordMonth(startTime, endTime).then((monthModel) {
      setState(() {
        _monthModel = monthModel;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // 获取当月数据
    getCurrentMonthDatas();

    // 订阅监听
    bus.add(bus.bookkeepingEventName, (arg) {
      getCurrentMonthDatas();
    });

    // 滑动监听
    _controller.addListener(() {
      if (_controller.offset < 200 && _isShowToTopBtn) {
        setState(() {
          _isShowToTopBtn = false;
        });
      } else if (_controller.offset >= 200 && _isShowToTopBtn == false) {
        setState(() {
          _isShowToTopBtn = true;
        });
      }
    });
  }

  double maxOffset = 150;
  double opacityValue = 0;

  void _onScrol(offset) {
    double alpha = offset / maxOffset;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      opacityValue = alpha;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 适配
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification &&
                    notification.depth == 0) {
                  //如果是
                  _onScrol(notification.metrics.pixels);
                }
              },
              child: CustomScrollView(
                controller: _controller,
                slivers: _sliverBuilder(),
              ),
            ),
          ),
          Container(
            height: appbarHeight + MediaQuery.of(context).padding.top,
            child: MyAppBar(
              barStyle: opacityValue < 0.3
                  ? StatusBarStyle.light
                  : StatusBarStyle.dark,
              backgroundColor: Colors.white.withOpacity(1.0 * opacityValue),
              isBack: false,
              titleWidget: _buildTitle(),
            ),
          )
        ],
      ),
      floatingActionButton: _isShowToTopBtn
          ? HighLightWell(
              onTap: () {
                _controller.animateTo(0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 35,
                height: 35,
                child: Image.asset(
                  Utils.getImagePath('icons/arrow_upward'),
                ),
              ),
            )
          : null,
    );
  }

  // 标题
  _buildTitle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ButtonTheme(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: FlatButton(
              child: (myYear1 == "1971")
                  ? Icon(Icons.chevron_left,color: Colors.white,)
                  : Text(
                      '$myYear1-$myMonth1',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(34),
                          color: Colors.white),
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
                          getCurrentMonthDatas();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          Text(
            "首页",
            style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(34),
                color: Colors.white),
          ),
          ButtonTheme(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: FlatButton(
              child: (myYear2 == "2055")
                  ? Icon(Icons.chevron_right,color: Colors.white,)
                  : Text(
                      '$myYear2-$myMonth2',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(34),
                          color: Colors.white),
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
                          getCurrentMonthDatas();
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

  /// List
  List<Widget> _sliverBuilder() {
    return <Widget>[
      SliverAppBar(
        elevation: 0.0, //去除导航栏阴影
        pinned: false, //导航栏固定
        expandedHeight: MediaQuery.of(context).padding.top +
            ScreenUtil.getInstance().setWidth(390),
        flexibleSpace: _flexibleSpaceBar(),
      ),
      _monthModel.recordLsit.length > 0
          ? SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                var model = _monthModel.recordLsit[index];
                if (model.runtimeType == BillRecordModel) {
                  return _buildItem(model);
                } else {
                  return _buildTimeTag(model);
                }
              }, childCount: _monthModel.recordLsit.length),
            )
          : SliverPadding(
              padding:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(120)),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return const StateLayout(
                    hintText: '没有账单',
                  );
                }, childCount: 1),
              ),
            ),
    ];
  }

  /// 头部伸展视图
  Widget _flexibleSpaceBar() {
    return FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  Utils.getImagePath('icons/1', format: 'jpg'),
                ),
                fit: BoxFit.fill)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                      '${_monthModel.isBudget == 1 ? Utils.formatDouble(double.parse((_monthModel.budget - _monthModel.expenMoney).toStringAsFixed(2))) : Utils.formatDouble(double.parse((_monthModel.incomeMoney - _monthModel.expenMoney).toStringAsFixed(2)))}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil.getInstance().setSp(56),
                          color: Colors.white)),
                  Text(
                    '结余',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil.getInstance().setSp(35),
                        color: Colors.white),
                  ),
                  Gaps.vGap(ScreenUtil.getInstance().setHeight(15)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: _amountWidget(),
            )
          ],
        ),
      ),
    );
  }

  ///支出和收入widget
  Widget _amountWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: ScreenUtil.getInstance().setHeight(16),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${Utils.formatDouble(double.parse(_monthModel.expenMoney.toStringAsFixed(2)))}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(36),
                            color: Colors.white),
                      ),
                      Text('支出',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil.getInstance().setSp(26),
                              color: Colors.white))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: ScreenUtil.getInstance().setHeight(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${Utils.formatDouble(double.parse(_monthModel.incomeMoney.toStringAsFixed(2)))}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(36),
                            color: Colors.white),
                      ),
                      Text('收入',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil.getInstance().setSp(26),
                              color: Colors.white))
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  /// 构建账单
  _buildItem(BillRecordModel model) {
    return Container(
      child: HighLightWell(
          onTap: () {
            _showBottomSheet(model);
          },
          child: Stack(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          Utils.getImagePath('category/${model.image}'),
                          width: ScreenUtil.getInstance().setWidth(55),
                        ),
                        Gaps.hGap(12),
                        Text(
                          model.categoryName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil.getInstance().setSp(32),
                              color: Colours.black),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${Utils.formatDouble(model.money)}',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: ScreenUtil.getInstance().setSp(36),
                                color: Colours.dark),
                          ),
                        )
                      ],
                    ),
                    model.remark.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                                left:
                                    ScreenUtil.getInstance().setWidth(55) + 12,
                                top: 2),
                            child: Text(
                              model.remark,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: ScreenUtil.getInstance().setSp(30),
                                  color: Colours.black),
                            ),
                          )
                        : Gaps.empty,
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 0,
                bottom: 0,
                child: Gaps.line,
              )
            ],
          )),
    );
  }

  /// 构建头部日期
  Widget _buildTimeTag(BillRecordGroup group) {
    String moneyString = '';
    if (group.incomeMoney > 0) {
      moneyString = moneyString +
          '收入${Utils.formatDouble(double.parse(group.incomeMoney.toStringAsFixed(2)))}元';
    }
    if (group.expenMoney > 0) {
      moneyString = moneyString +
          '${group.incomeMoney > 0 == true ? '  ' : ''}支出${Utils.formatDouble(double.parse(group.expenMoney.toStringAsFixed(2)))}元';
    }

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: HighLightWell(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Gaps.hGap(10),
                      Text(
                        group.date,
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            color: Colors.black45),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      moneyString,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.getInstance().setSp(28),
                          color: Colors.black45),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Gaps.line,
            )
          ],
        ),
      ),
    );
  }

  /// 点击item弹出详情
  _showBottomSheet(BillRecordModel model) {
    if (model == null) {
      showToast('查询错误');
      return;
    }

    final TextStyle titleStyle = TextStyle(fontSize: 16, color: Colours.black);
    final TextStyle descStyle = TextStyle(fontSize: 16, color: Colours.black);

    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    var dateTime = DateTime.fromMillisecondsSinceEpoch(model.updateTimestamp);
    String timeString = dateFormat.format(dateTime);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 60,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Text(
                        '账单详情',
                        style: TextStyle(fontSize: 18),
                      ),
                      Positioned(
                        left: 0,
                        child: HighLightWell(
                          onTap: () async {
                            // 删除记录
                            var account = await dbAccount.getAccount(model.account);
                            var typeofA = account.typeofA;
                            dbAccount.accountBalanceAdd(model.account, model.money, typeofA);
                            dbHelp.deleteBillRecord(model.id).then((value) {
                              bus.trigger(bus.bookkeepingEventName);
                              NavigatorUtils.goBack(context);
                            });
                          },
                          borderRadius: BorderRadius.circular(3),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: Colours.gray_c, width: 0.5)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 4),
                              child: Text(
                                '删除',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: HighLightWell(
                          onTap: () {
                            NavigatorUtils.goBack(context);
                            Navigator.of(context).push(new MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) {
                                  return NewPage(
                                    recordModel: model,
                                  );
                                }));
                          },
                          borderRadius: BorderRadius.circular(3),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: Colours.gray_c, width: 0.5)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 4),
                              child: Text(
                                '编辑',
                                style: TextStyle(
                                    fontSize: 16, color: Colours.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.line,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: <Widget>[
                      Text('金额', style: titleStyle),
                      Gaps.hGap(20),
                      Expanded(
                        flex: 1,
                        child: Text('${Utils.formatDouble(model.money)}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            )),
                      )
                    ],
                  ),
                ),
                Gaps.line,
                model.account.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: <Widget>[
                            Text('账户', style: titleStyle),
                            Gaps.hGap(20),
                            Expanded(
                              flex: 1,
                              child: Text('${model.account}',
                                  textAlign: TextAlign.right, style: descStyle),
                            )
                          ],
                        ),
                      )
                    : Gaps.empty,
                Gaps.line,
                model.person.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: <Widget>[
                            Text('成员', style: titleStyle),
                            Gaps.hGap(20),
                            Expanded(
                              flex: 1,
                              child: Text('${model.person}',
                                  textAlign: TextAlign.right, style: descStyle),
                            )
                          ],
                        ),
                      )
                    : Gaps.empty,
                Gaps.line,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('分类', style: titleStyle),
                      Gaps.hGap(23),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                Utils.getImagePath(
                                  'category/${model.image}',
                                ),
                                width: 18,
                              ),
                              Gaps.hGap(5),
                              Text('${model.categoryName}',
                                  textAlign: TextAlign.right, style: descStyle)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Gaps.line,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: <Widget>[
                      Text('时间', style: titleStyle),
                      Gaps.hGap(20),
                      Expanded(
                        flex: 1,
                        child: Text('$timeString',
                            textAlign: TextAlign.right, style: descStyle),
                      )
                    ],
                  ),
                ),
                Gaps.line,
                model.remark.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: <Widget>[
                            Text('备注', style: titleStyle),
                            Gaps.hGap(20),
                            Expanded(
                              flex: 1,
                              child: Text('${model.remark}',
                                  textAlign: TextAlign.right, style: descStyle),
                            )
                          ],
                        ),
                      )
                    : Gaps.empty,
                MediaQuery.of(context).padding.bottom > 0
                    ? SizedBox(
                        height: MediaQuery.of(context).padding.bottom,
                      )
                    : Gaps.empty,
              ],
            ),
          );
        });
  }
}
