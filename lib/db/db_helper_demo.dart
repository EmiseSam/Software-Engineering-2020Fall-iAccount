import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:i_account/db/column.dart';
import 'package:i_account/db/account_classification.dart';
import 'package:flutter/services.dart';

import 'column.dart';

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
      print("成功获取数据库");
      return _db;
    }
    _db = await _initDb();
    print("成功创建数据库");
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
    //账户表
    String queryStringAccount = """
    CREATE TABLE $tableAccount(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnAccount TEXT NOT NULL,
      $columnMoney REAL,
      $columnBalance REAL
    )
    """;
    await db.execute(queryStringAccount);
  }

  //插入或者更新账户类型（已完成）
  Future<int> insertAccount(AccountClassification ac) async {
    var dbClient = await db;
    var result;
    try {
      if (ac.id == null) {
        result = await dbClient.insert(tableAccount, ac.toMap());
      } else {
        result = await dbClient.update(tableAccount, ac.toMap(),
            where: '$columnId = ?', whereArgs: [ac.id]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  //删除账户（已完成）
  Future<int> deleteAccount(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableAccount, where: '$columnId = ?', whereArgs: [id]);
  }

  //获取账户类型列表（已完成）
  Future<List> getAccountList() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(tableMember, columns: [columnId, columnMember]);
    List<AccountClassification> accounts = [];
    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
    }
    return accounts;
  }

  //查询某个账户的总金额（已完成）
  Future<double> accountSum(int id) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT $columnBalance FROM $tableAccount where: $columnId = $id");
    AccountClassification account = AccountClassification.fromMap(maps.first);
    return account.balance;
  }

  //计算账户剩余总额(已完成)
  Future<double> accountBalance(int id) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT $columnMoney FROM $tableAccount where: $columnId = $id");
    AccountClassification account = AccountClassification.fromMap(maps.first);
    return account.sum;
  }
}
