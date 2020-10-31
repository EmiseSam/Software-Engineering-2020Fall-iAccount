import 'package:flutter/material.dart';
import 'package:i_account/pages/tabs.dart';

class RouterJump extends StatefulWidget {
  @override
  _RouterJumpState createState() => _RouterJumpState();
}

class _RouterJumpState extends State<RouterJump> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
    });
    return MaterialApp(home: Tabs());
  }
}
