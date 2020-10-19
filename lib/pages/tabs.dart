import 'package:i_account/pages/home.dart';
import 'package:i_account/pages/more.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_account/pages/newbill.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  List _pageList = [HomePage(), NewPage(), MorePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,color:Colors.lightBlue),
              label: "首页",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add,color:Colors.lightBlue),
              label: "记账",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz,color:Colors.lightBlue),
              label: "更多",
            ),
          ],
          currentIndex: this._currentIndex,
          onTap: (int index) {
            setState(() {
              this._currentIndex = index;
            });
          }),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 5),
        child: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor:Colors.lightBlue,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return NewPage();
            }));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
