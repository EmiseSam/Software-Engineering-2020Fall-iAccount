import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/loginpages/patternlock-create.dart';

class PwchangePage extends StatefulWidget {
  @override
  _PwchangePageState createState() => _PwchangePageState();
}

class _PwchangePageState extends State<PwchangePage> {
  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '修改密码',
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
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
      ),
      body: Center(
          child: ListView(
            children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                title: Text("修改文字密码"),
                onTap: () {
                },
              ),
              ListTile(
                title: Text("修改图形密码"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PatternlockcreatePage()));
                },
              ),
            ]).toList(),
          )
      ),
    );
  }
}
