import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:i_account/db/column.dart';
import 'package:i_account/db/bill_classification.dart';
import 'package:i_account/db/account_classification.dart';

var dbHelp = new DBHelper();

class DBHelper {
  //单例
  DBHelper._internal();
  static DBHelper _singleton = new DBHelper._internal();
  factory DBHelper() => _singleton;

  Database _db;

  //获取数据库
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();
    return _db;
  }

  //初始化库
  _initDb() async {
    Directory document = await getApplicationDocumentsDirectory();
    String path = join(document.path, 'BCDb', 'BC.db');
    debugPrint(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  //创建数据库的同时创造分类表单
  void _onCreate(Database db, int version) async {
    // 支出类别表
    String queryStringExpen = """
    CREATE TABLE $tableBCE(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnClassification1 TEXT NOT NULL,
      $columnClassification2 TEXT,
    )
    """;
    await db.execute(queryStringExpen);

    // 收入类别表
    String queryStringInc = """
    CREATE TABLE $tableBCI(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnClassification1 TEXT NOT NULL,
      $columnClassification2 TEXT,
    )
    """;
    await db.execute(queryStringInc);

    //账户表
    String queryStringAccount = """
    CREATE TABLE $tableAccount(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnAccount TEXT NOT NULL,
      $columnMoney REAL DEFAULT(0.00),
    )
    """;
    await db.execute(queryStringAccount);
  }

  //新增/更新支出分类
  Future<int> updateBCE(BillClasssification bc) async {
    var dbClient = await db;
    var result;
    try {
      if (bc.id == null) {
        result = await dbClient.insert(tableBCE, bc.toMap());
      } else {
        result = await dbClient.update(tableBCE, bc.toMap(),
            where: '$columnId = ?', whereArgs: [bc.id]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  // 获取记账支出一级分类
  Future<List> getExpenCategory1() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT $columnClassification1 FROM $tableBCE', null);
    List list1 = result.toList();
    List list2 = new List();
    for (int i = 0; i < list1.length; i++) {
      if (!list2.contains(list1[i])) {
        list2.add(list1[i]);
      }
    }
    return list2;
  }

  // 获取记账支出二级分类
  Future<List> getExpenCategory2(String bc1) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT $columnClassification2 FROM $tableBCE where: '$columnClassification1 = ?'",
        [bc1]);
    List list1 = result.toList();
    List list2 = new List();
    for (int i = 0; i < list1.length; i++) {
      if (!list2.contains(list1[i])) {
        list2.add(list1[i]);
      }
    }
    return list2;
  }

  //删除支出一级分类
  Future<int> deleteBCE1(String bc1) async {
    var dbClient = await db;
    return await dbClient.delete(tableBCE,
        where: '$columnClassification1 = ?', whereArgs: [bc1]);
  }

  //删除支出二级分类
  Future<int> deleteBCE2(String bc1, String bc2) async {
    var dbClient = await db;
    return await dbClient.delete(tableBCE,
        where: '$columnClassification2 = ? AND $columnClassification2 = ?',
        whereArgs: [bc1, bc2]);
  }

  // 获取记账收入一级分类
  Future<List> getIncCategory1() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT $columnClassification1 FROM $tableBCI', null);
    List list1 = result.toList();
    List list2 = new List();
    for (int i = 0; i < list1.length; i++) {
      if (!list2.contains(list1[i])) {
        list2.add(list1[i]);
      }
    }
    return list2;
  }

  // 获取记账收入二级分类
  Future<List> getIncCategory2(String bc1) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT $columnClassification2 FROM $tableBCI where: '$columnClassification1 = ?'",
        [bc1]);
    List list1 = result.toList();
    List list2 = new List();
    for (int i = 0; i < list1.length; i++) {
      if (!list2.contains(list1[i])) {
        list2.add(list1[i]);
      }
    }
    return list2;
  }

  //新增/更新支出分类
  Future<int> updateBCI(BillClasssification bc) async {
    var dbClient = await db;
    var result;
    try {
      if (bc.id == null) {
        result = await dbClient.insert(tableBCI, bc.toMap());
      } else {
        result = await dbClient.update(tableBCI, bc.toMap(),
            where: '$columnId = ?', whereArgs: [bc.id]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  //删除收入一级分类
  Future<int> deleteBCI1(String bc1) async {
    var dbClient = await db;
    return await dbClient.delete(tableBCI,
        where: '$columnClassification1 = ?', whereArgs: [bc1]);
  }

  //删除收入二级分类
  Future<int> deleteBCI2(String bc1, String bc2) async {
    var dbClient = await db;
    return await dbClient.delete(tableBCI,
        where: '$columnClassification2 = ? AND $columnClassification2 = ?',
        whereArgs: [bc1, bc2]);
  }

  //计算账户剩余总额(未完成)
  Future<double> accountTotalize(String account) async {
    var dbClient = await db;
    double sum = (await dbClient.rawQuery(
        "SELECT $columnMoney FROM $tableAccount where: '$columnAccount = ?'",
        [account])) as double;
  }
}
