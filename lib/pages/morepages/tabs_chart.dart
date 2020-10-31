import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_account/pages/chartpages/chart_category.dart';
import 'package:i_account/pages/chartpages/chart_account.dart';
import 'package:i_account/pages/chartpages/chart_member.dart';
import 'package:i_account/pages/chartpages/chart_project.dart';
import 'package:i_account/pages/chartpages/chart_store.dart';

class TabsChart extends StatefulWidget {
  @override
  _TabsChartState createState() => _TabsChartState();
}

class _TabsChartState extends State<TabsChart> {
  int _currentIndex = 0;
  List _pageList = [ChartCategoryPage(), ChartAccountPage(), ChartMemberPage(),ChartProjectPage(),ChartStorePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
            BottomNavigationBarItem(
              icon: Icon(Icons.drive_file_rename_outline, color: Colors.lightBlue),
              label: "按项目查看",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store, color: Colors.lightBlue),
              label: "按商家查看",
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
