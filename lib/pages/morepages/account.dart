import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:i_account/pages/accountpages/account_type_choice.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:i_account/routers/fluro_navigator.dart';
import 'package:i_account/res/styles.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  String name;
  String amount;

  TextStyle _bannerText = TextStyle(fontSize: 14.0, color: Colors.white);

  // 总资产
  num totalAssets = 666666.66;

  // 总负债
  num totalLiabilities = 6666.6666;

  // 是否可见
  bool _isVisible = true;

  // 账户列表
  List<dynamic> list;


  @override
  void initState() {
    super.initState();
  }

  // 定义下拉加载控制器
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  // 下拉刷新
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '资产',
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        //appBar: MyAppBar(
          //titleWidget: _buildAppBarTitle(),
        //),
        body: MediaQuery.removePadding(
          // 移除上边距
          removeTop: false,
          context: context,
          child: Container(
            color: Color(0xffF6F6F6),
            child: Column(
              children: <Widget>[
                Banner(
                  isVisible: _isVisible,
                  totalAssets: totalAssets,
                  totalLiabilities: totalLiabilities,
                  bannerText: _bannerText,
                  onChange: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                ),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    header: WaterDropMaterialHeader(
                      color: Colors.white,
                      backgroundColor: Color(0xffFF5267),
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: ListView(
                      children: <Widget>[
                        PanelWidget(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// banner
class Banner extends StatelessWidget {
  const Banner({
    Key key,
    @required this.totalAssets,
    @required this.isVisible,
    @required this.totalLiabilities,
    @required TextStyle bannerText,
    this.onChange,
  })  : _bannerText = bannerText,
        super(key: key);

  final num totalAssets;
  final bool isVisible;
  final num totalLiabilities;
  final TextStyle _bannerText;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 20.0,
          left: 15.0,
          right: 5.0),
//      padding: EdgeInsets.all(20.0),
      height: 203.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xffF07D59), Color(0xffEB4F70)]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  NavigatorUtils.goBack(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
              Gaps.hGap(107.0),
              Text('账户', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),),
              Gaps.hGap(80.0),
              IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  if (onChange != null) {
                    onChange();
                  }
                },
                icon: Icon(
                  isVisible ? Icons.visibility_off : Icons.visibility,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AccounttypechoicePage()));
                },
                icon: Icon(
                  Icons.add,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Gaps.vGap(10.0),
          Text(
            '净资产',
            style: TextStyle(color: Colors.white, fontSize: 14.0),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(
                text: isVisible
                    ? ((totalAssets - totalLiabilities).toInt() ?? 0).toString()
                    : '*****',
                style: TextStyle(
                  fontSize: 36.0,
                ),
                children: [
                  if (isVisible == true)
                    TextSpan(text: '.', style: TextStyle(fontSize: 20.0)),
                  if (isVisible == true)
                    TextSpan(
                      text: (int.tryParse((totalAssets - totalLiabilities)
                          .toStringAsFixed(2)
                          .split('.')[1]))
                          .toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                '总资产',
                style: _bannerText,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  isVisible
                      ? (totalAssets.toInt()).toStringAsFixed(2)
                      : '*****',
                  style: _bannerText,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                width: 1.0,
                height: 10.0,
                color: Colors.white,
              ),
              Text(
                '总负债',
                style: _bannerText,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  isVisible
                      ? (totalLiabilities.toInt()).toStringAsFixed(2)
                      : '*****',
                  style: _bannerText,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PanelWidget extends StatelessWidget {
  const PanelWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _accountTitleStyle = TextStyle(
      fontSize: 12.0,
      color: Colors.black45,
    );

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '我的账户',
                  style: _accountTitleStyle,
                ),
                Text(11111.toStringAsFixed(2), style: _accountTitleStyle),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              rowItem(),
              rowItem(),
              rowItem(showBorder: false),
            ],
          )
        ],
      ),
    );
  }

  Container rowItem({bool showBorder = true}) {
    print(showBorder);
    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: (showBorder == true) ? 0.33 : 0,
            color: (showBorder == true) ? Colors.black12 : Colors.transparent,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.account_balance_wallet,
                size: 20.0,
              ),
              SizedBox(
                width: 6.0,
              ),
              Text('支付宝'), //TODO 这个地方要接入数据库！ 变成可以更改的
            ],
          ),
          Text(
            500.toStringAsFixed(2),
            style: TextStyle(fontSize: 16.0),
          )
        ],
      ),
    );
  }
}
