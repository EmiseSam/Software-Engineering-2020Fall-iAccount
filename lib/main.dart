import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:i_account/pages/login.dart';
import 'package:i_account/pages/settingspages/darkmode_provider.dart';
import 'package:provider/provider.dart';

void main() {
  //透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DarkModeProvider()),
      ],
      child: Consumer<DarkModeProvider>(
        builder: (context, darkModeProvider, _) {
          return darkModeProvider.darkMode == 2
              ? MaterialApp(
            title: 'iAccount',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData.dark(),
            home: LoginPage(),
          )
              : MaterialApp(
            title: 'iAccount',
            theme: darkModeProvider.darkMode == 1
                ? ThemeData.dark()
                : ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginPage(),
          );
        },
      ),
    );
  }
}


