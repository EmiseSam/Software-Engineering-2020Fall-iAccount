import 'package:flutter/material.dart';
import 'package:i_account/res/colours.dart';
import 'package:i_account/routers/fluro_navigator.dart';
import 'package:i_account/pages/newbillpages/income.dart';
import 'package:i_account/pages/newbillpages/expend.dart';

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  NavigatorUtils.goBack(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: Colours.app_main,
                ),
              ),
              title: Text(
                '新建账单',
                style: TextStyle(
                  color: Colours.app_main,
                ),
              ),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: '支出',
                  ),
                  Tab(
                    text: '收入',
                  ),
                ],
                controller: _tabController,
                labelColor: Colours.app_main,
              )),
          body: TabBarView(controller: _tabController, children: <Widget>[
            ExpendPage(),
            IncomePage(),
          ])));
}
