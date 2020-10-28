import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:i_account/db/column.dart';
import 'package:i_account/db/account_classification.dart';
import 'package:i_account/db/member.dart';
import 'column.dart';

var dbAccount = new DBHelper();

class DBHelper {
  //单例
  DBHelper._internal();
  static DBHelper _singleton = new DBHelper._internal();
  factory DBHelper() => _singleton;

  Database _db;

  //获取数据库
  Future<Database> get db async {
    if (_db != null) {
      print("成功获取账户数据库");
      return _db;
    }
    _db = await _initDb();
    print("成功创建账户数据库");
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
      $columnBalance REAL,
      $columntypeofA INTEGER
    )
    """;
    await db.execute(queryStringAccount);

    //成员表
    String queryStringMember = """
    CREATE TABLE $tableMember(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnMember TEXT NOT NULL
    )
    """;
    await db.execute(queryStringMember);
  }

  //插入或者更新账户（已完成）
  Future<int> insertAccount(AccountClassification ac) async {
    print('正在更新账户');
    var dbClient = await db;
    var result;
    List<Map> maps = await dbClient.query(tableAccount, columns: [
      columnId,
      columnAccount,
      columnMoney,
      columnBalance,
      columntypeofA
    ]);
    List<AccountClassification> accounts = new List();
    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
    }
    List templist = new List();
    accounts.forEach((element) {
      templist.add(element.account);
    });
    try {
      if (ac.id != null) {
        result = await dbClient.update(tableAccount, ac.toMap(),
            where: '$columnId = ?', whereArgs: [ac.id]);
        print('已更新账户');
      } else if (templist.contains(ac.account)) {
        result = await dbClient.update(tableAccount, ac.toMap(),
            where: '$columnId = ?', whereArgs: [ac.id]);
        print('已有同名账户');
      } else {
        result = await dbClient.insert(tableAccount, ac.toMap());
        print('成功添加账户');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  //删除账户（已完成）
  Future<int> deleteAccount(String account) async {
    var dbClient = await db;
    var result = await dbClient.delete(tableAccount,
        where: '$columnAccount = ?', whereArgs: [account]);
    print('正在删除账户');
    return result;
  }

  //获取单个用户
  Future<AccountClassification> getAccount(String ac) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableAccount,
        columns: [
          columnId,
          columnAccount,
          columnMoney,
          columnBalance,
          columntypeofA
        ],
        where: '$columnAccount = ?',
        whereArgs: [ac]);
    AccountClassification account = AccountClassification.fromMap(maps.first);
    print('正在获取账户');
    return account;
  }

  //获取账户列表（已完成）
  Future<List> getAccountList() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableAccount, columns: [
      columnId,
      columnAccount,
      columnMoney,
      columnBalance,
      columntypeofA
    ]);
    List<AccountClassification> accounts = new List();
    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
    }
    print('正在获取所有账户列表');
    return accounts;
  }

  //获取某一种类的所有账户
  Future<List> getAccounts(int typeofA) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT * FROM $tableAccount WHERE $columntypeofA = $typeofA");
    List<AccountClassification> accounts = new List();
    print('正在获取$typeofA 类账户');
    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
      print(accounts[i].account);
    }
    return accounts;
  }

  //查询单个账户的余额（已完成）
  Future<double> getAccountSum(String ac) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT $columnBalance FROM $tableAccount where: $columnAccount = $ac");
    AccountClassification account = AccountClassification.fromMap(maps.first);
    print('正在查询$ac 的余额');
    return account.balance;
  }

  //查询单个账户总金额(已完成)
  Future<double> getAccountBalance(String ac) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT $columnMoney FROM $tableAccount where: $columnAccount = $ac");
    print('正在查询$ac 的总金额');
    AccountClassification account = AccountClassification.fromMap(maps.first);
    return account.sum;
  }

  //查询增添账单后单个账户余额
  Future<double> accountBalanceCal(String ac, double money, int typeofA) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableAccount,
        columns: [
          columnId,
          columnAccount,
          columnMoney,
          columnBalance,
          columntypeofA
        ],
        where: '$columnAccount = ?',
        whereArgs: [ac]);
    AccountClassification account = AccountClassification.fromMap(maps.first);
    print(account.balance);
    if (typeofA == 0) {
      account.balance -= money;
    } else {
      account.balance += money;
    }
    await dbClient.update(tableAccount, account.toMap(),
        where: '$columnId = ?', whereArgs: [account.id]);
    print('增加$money');
    print('正在计算$ac 的余额');
    return account.balance;
  }

  //查询删除账单后单个账户余额
  Future<double> accountBalanceAdd(String ac, double money, int typeofA) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableAccount,
        columns: [
          columnId,
          columnAccount,
          columnMoney,
          columnBalance,
          columntypeofA
        ],
        where: '$columnAccount = ?',
        whereArgs: [ac]);
    AccountClassification account = AccountClassification.fromMap(maps.first);
    print(account.balance);
    if (typeofA == 0) {
      account.balance += money;
    } else {
      account.balance -= money;
    }
    await dbClient.update(tableAccount, account.toMap(),
        where: '$columnId = ?', whereArgs: [account.id]);
    print('删除$money');
    print('正在计算$ac 的余额');
    return account.balance;
  }

  //计算单类资产
  Future<double> accountsTotalize(int typeofA) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT * FROM $tableAccount WHERE $columntypeofA = $typeofA");
    List<AccountClassification> accounts = new List();

    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
    }
    double money = 0;
    accounts.forEach((element) {
      money += element.balance;
    });
    print('正在计算$typeofA 类账户总额');
    return money;
  }

  //插入或者更新成员
  Future<int> insertMember(Member m) async {
    print('正在更新成员');
    var dbClient = await db;
    var result;
    List<Map> maps =
    await dbClient.query(tableMember, columns: [columnId, columnMember]);
    List<Member> members = new List();
    for (int i = 0; i < maps.length; i++) {
      members.add(Member.fromMap(maps[i]));
    }
    List templist = new List();
    members.forEach((element) {
      templist.add(element.member);
    });
    try {
      if (m.id != null) {
        result = await dbClient.update(tableMember, m.toMap(),
            where: '$columnId = ?', whereArgs: [m.id]);
        print('已更新成员');
      } else if (templist.contains(m.member)) {
        result = await dbClient.update(tableMember, m.toMap(),
            where: '$columnId = ?', whereArgs: [m.id]);
        print('已有同名成员');
      } else {
        result = await dbClient.insert(tableMember, m.toMap());
        print('成功添加成员');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  //删除成员
  Future<int> deleteMember(String m) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableMember, where: '$columnMember = ?', whereArgs: [m]);
  }

  //获取成员列表
  Future<List> getMember() async {
    var dbClient = await db;
    List<Map> maps =
    await dbClient.query(tableMember, columns: [columnId, columnMember]);
    List<Member> members = new List();
    for (int i = 0; i < maps.length; i++) {
      members.add(Member.fromMap(maps[i]));
    }
    print('正在获取所有账户列表');
    return members;
  }
}
