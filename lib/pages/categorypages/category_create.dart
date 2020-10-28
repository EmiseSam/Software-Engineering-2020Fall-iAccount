import 'package:i_account/bill/models/category_model.dart';
import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/morepages/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_account/widgets/my_pickertool.dart';
import 'package:i_account/widgets/highlight_well.dart';
import 'package:flutter/services.dart';
import 'package:i_account/db/db_helper.dart';

class CategoryCreatePage extends StatefulWidget {
  @override
  _CategoryCreatePageState createState() =>
      _CategoryCreatePageState();
}

class _CategoryCreatePageState extends State<CategoryCreatePage> {

  TextEditingController _categoryName = new TextEditingController();
  var _typePickerData = ["支出分类", "收入分类"];
  String _categoryType = '';
  int _categoryTypeDB = 1;

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '创建分类',
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
        onPressed: () async{
          print(_categoryTypeDB);
          CategoryItem category = new CategoryItem(_categoryName.text, null);
          dbHelp.insertSort(category, _categoryTypeDB);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CategoryPage()), ModalRoute.withName('/'));
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

        },
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 48,
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text("分类名称", style: TextStyle(fontSize: 18),),
            ),
            TextField(
              decoration: new InputDecoration(
                hintText: "请输入分类名称",
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
            Container(
              height: 48,
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text("分类类型", style: TextStyle(fontSize: 18),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: HighLightWell(
                onTap: () {
                  MyPickerTool.showStringPicker(context,
                      data: _typePickerData,
                      normalIndex: 0,
                      title: "请选择", clickCallBack: (int index, var str) {
                        setState(() {
                          _categoryType = str;
                          _categoryTypeDB = index + 1;
                          print(_categoryTypeDB);
                        });
                      });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colours.gray, width: 0.6)),
                  child: Text(_categoryType.isEmpty ? '支出分类' : _categoryType),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


