import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_account/pages/categorypages/category_income.dart';
import 'package:i_account/pages/categorypages/category_expen.dart';
import 'package:i_account/pages/categorypages/category_create.dart';

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
          "分类",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 25.0,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoryCreatePage()));
            },
          ),
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
                      return CategoryExpenPage();
                    }));
                }
            ),
            ListTile(
                title: Text("管理收入类别"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CategoryIncomePage();
                      }));
                }),
          ]).toList(),
        ),
      ),
    );
  }
}
