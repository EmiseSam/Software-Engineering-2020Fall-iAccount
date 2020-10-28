import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_account/pages/categorypages/bill_search_category_withtype.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/router_jump.dart';

class CategoryExpenPage extends StatefulWidget {
  @override
  _CategoryExpenPageState createState() => _CategoryExpenPageState();
}

class _CategoryExpenPageState extends State<CategoryExpenPage> {

  List categoryNames = new List();

  Future<List> _loadCategoryNames() async {
    List list = await dbHelp.getExpenCategory();
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.name);
    });
    print(categoryNames.length);
    return listTemp;
  }

  @override
  void initState() {
    _loadCategoryNames().then((value) => setState(() {
      categoryNames = value;
    }));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "支出分类",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child:ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, item) {
            return buildListData(context, categoryNames[item],
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: (categoryNames.length == null) ? 0 : categoryNames.length,
        ),
      ),
    );
  }

  Widget buildListData(BuildContext context, String titleItem) {
    return new ListTile(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return BillSearchListCategoryWithtype(titleItem,1);
        }));
      },
      onLongPress: () async {
        if(titleItem == '其他'){
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("提示"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("该分类不能删除！")],
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
        }else{
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("提示"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("是否删除该分类？")],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text("取消"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      dbHelp.deleteSort(titleItem, 1);
                      dbHelp.deleteSortBills(titleItem, 1);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouterJump()), ModalRoute.withName('/'));
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("提示"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[Text("已经删除该分类！")],
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
      leading: Icon(Icons.category),
      title: new Text(
        titleItem,
        style: TextStyle(fontSize: 18),
      ),
      trailing: new Icon(Icons.keyboard_arrow_right),
    );
  }
}
