import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:i_account/pages/login.dart';
import 'package:i_account/pages/tabs.dart';

class PageJump extends StatefulWidget {
  @override
  _PageJumpState createState() => _PageJumpState();
}

class _PageJumpState extends State<PageJump> {

  bool locksetting = false;

  @override
  void initState() {
    super.initState();
    _getLockState();//获取本地存储的数据
  }

  _getLockState() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      locksetting = sharedPreferences.get('lockset') ?? false;//从本地存储的数据获取，如果没有设置为false，如果有设置为存储的数据
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: locksetting ? LoginPage() : Tabs()
    );
  }
}
