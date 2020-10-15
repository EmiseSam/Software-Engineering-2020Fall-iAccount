import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/settingspages/darkmode_provider.dart';
import 'package:provider/provider.dart';

class DarkmodePage extends StatefulWidget {
  @override
  _DarkmodePageState createState() => _DarkmodePageState();
}

class _DarkmodePageState extends State<DarkmodePage> {
  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '深色模式',
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
              title: Text("浅色模式"),
              onTap: () {
                Provider.of<DarkModeProvider>(context, listen: false)
                    .changeMode(0);
              },
            ),
            ListTile(
              title: Text("深色模式"),
              onTap: () {
                Provider.of<DarkModeProvider>(context, listen: false)
                    .changeMode(1);
              },
            ),
            ListTile(
              title: Text("跟随系统"),
              onTap: () {
                Provider.of<DarkModeProvider>(context, listen: false)
                    .changeMode(2);
              },
            )
          ]).toList(),
            )
        )
    );
  }
}
