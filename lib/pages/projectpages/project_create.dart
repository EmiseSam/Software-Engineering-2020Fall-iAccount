import 'package:i_account/db/db_helper.dart';
import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/router_jump.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:i_account/bill/models/project_model.dart';

class ProjectCreatePage extends StatefulWidget {
  @override
  _ProjectCreatePageState createState() => _ProjectCreatePageState();
}

class _ProjectCreatePageState extends State<ProjectCreatePage> {
  TextEditingController _projectName = new TextEditingController();

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '创建项目',
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
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
        actionName: "确定",
        onPressed: () async {
          if (_projectName.text.isNotEmpty) {
            Project m = new Project(_projectName.text);
            int idReturn = await dbHelp.insertProject(m);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouterJump()), ModalRoute.withName('/'));
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[idReturn != -1? Text("项目创建成功！") : Text("已有同名项目！")],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text("确定"),
                    ),
                  ],
                );
              },
            ).then((val) {
              print(val);
            });
          } else {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[Text("项目名不能为空！")],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("确定"),
                    ),
                  ],
                );
              },
            ).then((val) {
              print(val);
            });
          }
        },
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 48,
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                "项目名称",
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextField(
              decoration: new InputDecoration(
                hintText: "请输入项目名称",
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid),
                ),
                prefixIcon: Icon(Icons.person),
              ),
              controller: _projectName,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}
