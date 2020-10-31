import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_account/pages/categorypages/category_income_first.dart';
import 'package:i_account/pages/categorypages/category_expen_first.dart';
import 'package:i_account/pages/categorypages/category_create_first.dart';


class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "分类管理",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.looks_one), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryCreateFirstPage()));
          }),
        ],
      ),
      body: Center(
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              title: Text("管理支出类别"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CategoryExpenFirstPage();
                    }));
                }
            ),
            ListTile(
                title: Text("管理收入类别"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CategoryIncomeFirstPage();
                      }));
                }),
          ]).toList(),
        ),
      ),
    );
  }
}
