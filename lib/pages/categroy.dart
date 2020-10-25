import 'package:i_account/res/colours.dart';
import 'package:i_account/res/styles.dart';
import 'package:i_account/bill/models/bill_record_response.dart';
import 'package:i_account/bill/models/category_model.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategroyView extends StatefulWidget {
  const CategroyView({Key key, this.recordModel}) : super(key: key);
  final BillRecordModel recordModel;

  @override
  State<StatefulWidget> createState() => _CategroyViewState();
}

class _CategroyViewState extends State<CategroyView> with TickerProviderStateMixin {

  AnimationController _animationController;
  AnimationController _tapItemController;

  /// 支出类别数组
  List<CategoryItem> _expenObjects = List();

  /// 收入类别数组
  List<CategoryItem> _inComeObjects = List();

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

  /// 获取支出类别数据
  Future<void> _loadExpenDatas() async {
    dbHelp.getInitialExpenCategory().then((list) {
      List<CategoryItem> models = list.map((i) => CategoryItem.fromJson(i)).toList();
      if (_expenObjects.length > 0) {
        _expenObjects.removeRange(0, _expenObjects.length);
      }
      _expenObjects.addAll(models);

      if (widget.recordModel != null && widget.recordModel.type == 1) {
        _selectedIndexLeft = _expenObjects
            .indexWhere((item) => item.name == widget.recordModel.categoryName);
      }

      setState(() {});
    });
  }

  Future<void> _loadIncomeDatas() async {
    dbHelp.getInitialIncomeCategory().then((list) {
      List<CategoryItem> models =
      list.map((i) => CategoryItem.fromJson(i)).toList();
      if (_inComeObjects.length > 0) {
        _inComeObjects.removeRange(0, _inComeObjects.length);
      }
      _inComeObjects.addAll(models);

      if (widget.recordModel != null && widget.recordModel.type == 2) {
        _selectedIndexRight = _inComeObjects
            .indexWhere((item) => item.name == widget.recordModel.categoryName);
      }

      setState(() {});
    });
  }

  void _updateInitData() {
    if (widget.recordModel != null) {

      if (widget.recordModel.type == 2) {
        _tabController.index = 1;
      }
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
    _loadExpenDatas();
    _loadIncomeDatas();
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
    return Container(
      child: Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          brightness: Brightness.light,
          elevation: 0,
          title: Text('分类'),
          leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.times),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TabBar(
                // tabbar菜单
                controller: _tabController,
                tabs: tabs,
                indicatorColor: Colours.app_main,
                unselectedLabelColor: Colours.app_main.withOpacity(0.8),
                labelColor: Colours.app_main,
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                indicatorWeight: 1,
                // // 下划线高度
                // isScrollable: true, // 是否可以滑动
              ),

              Expanded(
                flex: 1,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    _buildExpenCategory(),
                    _buildIncomeCategory(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 选中index
  int _selectedIndexLeft = 0;

  /// 支出构建
  _buildExpenCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GridView.builder(
        key: PageStorageKey<String>("0"), //保存状态
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            mainAxisSpacing: 0,
            crossAxisSpacing: 8),
        itemCount: _expenObjects.length,
        itemBuilder: (context, index) {
          return _getCategoryItem(
              _expenObjects[index], index, _selectedIndexLeft);
        },
      ),
    );
  }

  /// 选中index
  int _selectedIndexRight = 0;

  /// 收入构建
  _buildIncomeCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GridView.builder(
        key: PageStorageKey<String>("1"), //保存状态
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            mainAxisSpacing: 0,
            crossAxisSpacing: 8),
        itemCount: _inComeObjects.length,
        itemBuilder: (context, index) {
          return _getCategoryItem(
              _inComeObjects[index], index, _selectedIndexRight);
        },
      ),
    );
  }

  /// 构建类别item
  _getCategoryItem(CategoryItem item, int index, selectedIndex) {
    return GestureDetector(
      onTap: () {
        if (_tabController.index == 0) {
          //左边支出类别
          if (_selectedIndexLeft != index) {
            _selectedIndexLeft = index;
            _tapItemController.forward();
            setState(() {});
          }
        } else {
          //右边收入类别
          if (_selectedIndexRight != index) {
            _selectedIndexRight = index;
            _tapItemController.forward();
            setState(() {});
          }
        }

        var data = {
          'categroyFirst': item.name,
          'categroySecond': item.name,
          'itemName': item.name,
          'itemImage': item.image,
          'itemType': _tabController.index + 1,
        };
        Navigator.of(context).pop(data);
      },
      child: AnimatedBuilder(
        animation: _tapItemController,
        builder: (BuildContext context, Widget child) {
          return ClipOval(
            child: Container(
              color: selectedIndex == index ? Colours.app_main : Colors.white,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Utils.getImagePath('category/${item.image}'),
                    width: selectedIndex == index
                        ? ScreenUtil.getInstance()
                        .setWidth(60 + _tapItemController.value * 6)
                        : ScreenUtil.getInstance().setWidth(50),
                    color: selectedIndex == index ? Colors.white : Colors.black,
                  ),
                  Gaps.vGap(3),
                  Text(
                    item.name,
                    style: TextStyle(
                        color: selectedIndex == index
                            ? Colors.white
                            : Colours.black,
                        fontSize: selectedIndex == index
                            ? ScreenUtil.getInstance()
                            .setSp(25 + 3 * _tapItemController.value)
                            : ScreenUtil.getInstance().setSp(25)),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
