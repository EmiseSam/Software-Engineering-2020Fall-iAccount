import 'package:i_account/db/db_helper.dart';
import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/router_jump.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:i_account/bill/models/member_model.dart';

class MemberCreatePage extends StatefulWidget {
  @override
  _MemberCreatePageState createState() => _MemberCreatePageState();
}

class _MemberCreatePageState extends State<MemberCreatePage> {
  TextEditingController _memberName = new TextEditingController();

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '创建成员',
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
          if (_memberName.text.isNotEmpty) {
            Member m = new Member(_memberName.text);
            int idReturn = await dbHelp.insertMember(m);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouterJump()), ModalRoute.withName('/'));
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[idReturn != -1? Text("成员创建成功！") : Text("已有同名成员！")],
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
                      children: <Widget>[Text("成员名不能为空！")],
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
                "成员名称",
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextField(
              decoration: new InputDecoration(
                hintText: "请输入成员名称",
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid),
                ),
                prefixIcon: Icon(Icons.person),
              ),
              controller: _memberName,
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
