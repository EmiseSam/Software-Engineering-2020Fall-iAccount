import 'package:i_account/res/colours.dart';
import 'package:i_account/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '关于',
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
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                "软件版本",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //color: Colors.black,
                  fontSize: 24.0,
                ),
              ),
              Gaps.vGap(20),
              Text(
                "V0.5.0.1027",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //color: Colours.app_main,
                  fontSize: 30.0,
                ),
              ),
              Gaps.vGap(20),
              Text(
                "开发团队",
                textAlign: TextAlign.left,
                style: TextStyle(
                  //color: Colors.black,
                  fontSize: 24.0,
                ),
              ),
              ListTile(
                leading: ClipOval(
                  child: Image.asset("assets/images/profile/1.jpg",
                      fit: BoxFit.cover, height: 60, width: 60),
                ),
                title: Text("胡聪"),
                subtitle: Text("2018级计算机5班"),
              ),
              Gaps.vGap(3),
              ListTile(
                leading: ClipOval(
                  child: Image.asset("assets/images/profile/2.jpg",
                      fit: BoxFit.cover, height: 60, width: 60),
                ),
                title: Text("王牧天"),
                subtitle: Text("2018级计算机5班"),
              ),
              Gaps.vGap(3),
              ListTile(
                leading: ClipOval(
                  child: Image.asset("assets/images/profile/3.jpg",
                      fit: BoxFit.cover, height: 60, width: 60),
                ),
                title: Text("郭星远"),
                subtitle: Text("2018级计算机6班"),
              ),
              Gaps.vGap(3),
              ListTile(
                leading: ClipOval(
                  child: Image.asset("assets/images/profile/4.jpg",
                      fit: BoxFit.cover, height: 60, width: 60),
                ),
                title: Text("郝旻小昕"),
                subtitle: Text("2018级计算机5班"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
