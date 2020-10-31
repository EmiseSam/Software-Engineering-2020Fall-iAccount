import 'package:i_account/bill/models/category_model.dart';
import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/router_jump.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:i_account/db/db_helper.dart';


class CategoryCreateSecondExpenPage extends StatefulWidget {
  CategoryCreateSecondExpenPage(this.categoryName1) : super();
  final categoryName1;
  @override
  _CategoryCreateSecondExpenPageState createState() => _CategoryCreateSecondExpenPageState();
}

class _CategoryCreateSecondExpenPageState extends State<CategoryCreateSecondExpenPage> {
  TextEditingController _categoryName = new TextEditingController();

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '创建${widget.categoryName1}分类下的二级分类',
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
          if (_categoryName.text.isNotEmpty) {
            CategoryItem tempItem = new CategoryItem(widget.categoryName1,_categoryName.text);
            await dbHelp.insertCategory(tempItem, 1);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => RouterJump()),
                ModalRoute.withName('/'));
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[Text("分类创建成功！")],
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
          } else {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[Text("分类名不能为空！")],
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
                "二级分类名称",
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextField(
              decoration: new InputDecoration(
                hintText: "请输入二级分类名称",
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid),
                ),
                prefixIcon: Icon(Icons.category),
              ),
              controller: _categoryName,
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
