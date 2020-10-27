import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_account/pages/chartpages/chart_category.dart';
import 'package:i_account/pages/chartpages/chart_account.dart';
import 'package:i_account/pages/chartpages/chart_person.dart';

class TabsChart extends StatefulWidget {
  @override
  _TabsChartState createState() => _TabsChartState();
}

class _TabsChartState extends State<TabsChart> {
  int _currentIndex = 0;
  List _pageList = [ChartCategoryPage(), ChartAccountPage(), ChartPersonPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.category, color: Colors.lightBlue),
              label: "按分类查看",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet, color: Colors.lightBlue),
              label: "按账户查看",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.lightBlue),
              label: "按成员查看",
            ),
          ],
          currentIndex: this._currentIndex,
          onTap: (int index) {
            setState(() {
                this._currentIndex = index;
              }
            );
          }),
    );
  }
}
